using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases;

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

    public SendOperacionCreditoUseCase(
        IEntitySource<OperacionCredito> source,
        IIngestionSessionClient sessionClient,
        IIngestionStreamSender streamSender,
        ICheckpointStore checkpointStore)
    {
        _source = source;
        _sessionClient = sessionClient;
        _streamSender = streamSender;
        _checkpointStore = checkpointStore;
    }

    public async Task ExecuteAsync(
        int idLoadLocal = 0,
        CancellationToken cancellationToken = default)
    {
        var session = await _sessionClient.CreateSessionAsync(
            dataset: DatasetName,
            cancellationToken);

        var lastSequence = await _checkpointStore
            .GetLastSequenceAsync(session.SessionId, cancellationToken);

        var stream = _source.StreamAsync(idLoadLocal, cancellationToken);

        await _streamSender.StreamAsync(
            session,
            stream,
            lastSequence,
            cancellationToken);

        await _sessionClient.CommitAsync(
            session.SessionId,
            cancellationToken);
    }
}
