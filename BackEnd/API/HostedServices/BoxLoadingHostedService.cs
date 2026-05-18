using Application.Feactures.Loading.Commands.LoadBoxData;
using Microsoft.Extensions.Options;

namespace API.HostedServices;

public sealed class BoxLoadingOptions
{
    public int CheckIntervalSeconds { get; set; } = 30;
    public int MaxAttemptsPerBox    { get; set; } = 3;
}

public sealed class BoxLoadingHostedService : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly IOptionsMonitor<BoxLoadingOptions> _options;
    private readonly ILogger<BoxLoadingHostedService> _logger;

    public BoxLoadingHostedService(
        IServiceScopeFactory scopeFactory,
        IOptionsMonitor<BoxLoadingOptions> options,
        ILogger<BoxLoadingHostedService> logger)
    {
        _scopeFactory = scopeFactory;
        _options      = options;
        _logger       = logger;
    }

    protected override async Task ExecuteAsync(CancellationToken stoppingToken)
    {
        while (!stoppingToken.IsCancellationRequested)
        {
            var current = _options.CurrentValue;
            try
            {
                await ProcessReadyBoxesAsync(current.MaxAttemptsPerBox, stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "BoxLoadingHostedService: unhandled error; will retry next interval.");
            }

            try
            {
                await Task.Delay(
                    TimeSpan.FromSeconds(current.CheckIntervalSeconds),
                    stoppingToken);
            }
            catch (OperationCanceledException) when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
        }
    }

    private async Task ProcessReadyBoxesAsync(int maxAttempts, CancellationToken ct)
    {
        using var scope    = _scopeFactory.CreateScope();
        var loading        = scope.ServiceProvider.GetRequiredService<ILoadingRepository>();
        var sender         = scope.ServiceProvider.GetRequiredService<ISender>();

        var boxes = await loading.GetBoxesReadyForLoadingAsync(ct);

        _logger.LogInformation(
            "BoxLoadingHostedService: poll — {Count} box(es) in STAGING ready for LOADING.", boxes.Count);

        if (boxes.Count == 0)
            return;

        foreach (var (idCliente, idLoad) in boxes)
        {
            if (ct.IsCancellationRequested)
                break;

            var result = await sender.Send(
                new LoadBoxDataCommand(idCliente, idLoad, maxAttempts), ct);

            if (result.IsFailure)
                _logger.LogWarning(
                    "BoxLoadingHostedService: box {IdLoad} (client {IdCliente}) failed — {Error}",
                    idLoad, idCliente, result.Error);
        }
    }
}
