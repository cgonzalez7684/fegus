using Common.Share;
using Domain.Entities.FegusConfig;
using Microsoft.Extensions.Logging;

namespace Application.Feactures.Loading.Commands.LoadBoxData;

public sealed class LoadBoxDataCommandHandler : ICommandHandler<LoadBoxDataCommand>
{
    private readonly IBoxDataRepository _boxes;
    private readonly ILoadingRepository _loading;
    private readonly ILogger<LoadBoxDataCommandHandler> _logger;

    public LoadBoxDataCommandHandler(
        IBoxDataRepository boxes,
        ILoadingRepository loading,
        ILogger<LoadBoxDataCommandHandler> logger)
    {
        _boxes   = boxes;
        _loading = loading;
        _logger  = logger;
    }

    public async Task<Result> Handle(LoadBoxDataCommand request, CancellationToken ct)
    {
        var (idCliente, idLoad, maxAttempts) = request;

        // Fetch current box state to guard against concurrent transitions.
        var getResult = await _boxes.GetFeBoxDataLoadAsync(idCliente, idLoad, ct);
        var box = getResult.Data?.FirstOrDefault();

        if (box is null)
            return Result.Fail($"Box {idLoad} not found for client {idCliente}.", ErrorType.NotFound);

        if (box.StateCode != DataLoadState.Staging)
        {
            _logger.LogWarning(
                "LoadBoxData: box {IdLoad} (client {IdCliente}) is in state {State}, expected STAGING — skipping.",
                idLoad, idCliente, box.StateCode);
            return Result.Success();
        }

        // Transition to LOADING.
        box.StateCode      = DataLoadState.Loading;
        box.AttemptCount   = (box.AttemptCount ?? 0) + 1;
        var updateResult = await _boxes.UpdateFeBoxDataLoadAsync(box, ct);
        if (updateResult.SqlCode != 0)
            return Result.Fail($"Failed to transition box to LOADING: {updateResult.SqlMessage}", ErrorType.Technical);

        _logger.LogInformation(
            "LoadBoxData: box {IdLoad} (client {IdCliente}) transitioned to LOADING (attempt {Attempt}).",
            idLoad, idCliente, box.AttemptCount);

        // Execute data load for all 28 datasets.
        IReadOnlyList<DatasetLoadResult> results;
        try
        {
            results = await _loading.LoadAllDatasetsAsync(idCliente, idLoad, ct);
        }
        catch (Exception ex)
        {
            return await HandleFailureAsync(box, maxAttempts, ex.Message, ct);
        }

        var failed = results.Where(r => r.SqlCode != "00000").ToList();
        if (failed.Count > 0)
        {
            var errorSummary = string.Join("; ", failed.Select(f => $"{f.Dataset}:{f.SqlCode}:{f.SqlMessage}"));
            _logger.LogError(
                "LoadBoxData: box {IdLoad} (client {IdCliente}) — {Count} dataset(s) failed: {Errors}",
                idLoad, idCliente, failed.Count, errorSummary);
            return await HandleFailureAsync(box, maxAttempts, Truncate(errorSummary, 500), ct);
        }

        // All datasets loaded — advance to VALIDATING.
        box.StateCode          = DataLoadState.Validating;
        box.LastErrorMessage   = null;
        var finalUpdate = await _boxes.UpdateFeBoxDataLoadAsync(box, ct);
        if (finalUpdate.SqlCode != 0)
            return Result.Fail($"Failed to transition box to VALIDATING: {finalUpdate.SqlMessage}", ErrorType.Technical);

        _logger.LogInformation(
            "LoadBoxData: box {IdLoad} (client {IdCliente}) — all datasets loaded, transitioned to VALIDATING.",
            idLoad, idCliente);

        return Result.Success();
    }

    private async Task<Result> HandleFailureAsync(
        FeBoxDataLoad box, int maxAttempts, string errorMessage, CancellationToken ct)
    {
        box.LastErrorMessage = errorMessage;
        box.StateCode = (box.AttemptCount ?? 0) >= maxAttempts
            ? DataLoadState.Error
            : DataLoadState.Loading;

        await _boxes.UpdateFeBoxDataLoadAsync(box, ct);

        return Result.Fail(errorMessage, ErrorType.Technical);
    }

    private static string Truncate(string value, int maxLength)
        => value.Length <= maxLength ? value : value[..maxLength];
}
