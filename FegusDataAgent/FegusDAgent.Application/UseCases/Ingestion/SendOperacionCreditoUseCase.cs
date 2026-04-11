using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Ingestion;

/// <summary>
/// Orquesta lectura de operaciones de crédito desde el origen local y envío al API de ingestión por streaming.
/// </summary>
public sealed class SendOperacionCreditoUseCase
{
    private const string DatasetName = "operaciones_credito";

    private readonly IEntitySource<OperacionCredito> _source;
    private readonly IIngestionSessionClient _sessionClient;
    private readonly IIngestionStreamSender _streamSender;
    private readonly ICheckpointStore _checkpointStore;
    private readonly IEventLogger<SendOperacionCreditoUseCase> _logger;

    public SendOperacionCreditoUseCase(
        IEntitySource<OperacionCredito> source,
        IIngestionSessionClient sessionClient,
        IIngestionStreamSender streamSender,
        ICheckpointStore checkpointStore,
        IEventLogger<SendOperacionCreditoUseCase> logger)
    {
        _source = source;
        _sessionClient = sessionClient;
        _streamSender = streamSender;
        _checkpointStore = checkpointStore;
        _logger = logger;
    }

    public async Task ExecuteAsync(
        string token,
        int? idLoadLocal = 0,
        CancellationToken cancellationToken = default)
    {
        try
        {
            var session = await _sessionClient.CreateSessionAsync(
                dataset: DatasetName,
                token,
                cancellationToken);

            var lastSequence = await _checkpointStore
                .GetLastSequenceAsync(session.SessionId, cancellationToken);

            var stream = _source.GetDataStreamAsync(idLoadLocal, cancellationToken);

            await _streamSender.SendStreamAsync(
                session,
                stream,
                lastSequence,
                token,
                cancellationToken);

            await _sessionClient.CommitAsync(
                session.SessionId,
                token,
                cancellationToken);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.Error($"SendOperacionCredito failed for idLoadLocal={idLoadLocal}.", ex);
            throw;
        }
    }
}
