using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Ingestion;

public sealed class SendDeudoresUseCase
{
    private readonly IEntitySource<Deudor> _source;
    private readonly IIngestionSessionClient _sessionClient;
    private readonly IIngestionStreamSender _streamSender;
    private readonly ICheckpointStore _checkpointStore;
    private readonly IEventLogger<SendDeudoresUseCase> _logger;

    public SendDeudoresUseCase(
        IEntitySource<Deudor> source,
        IIngestionSessionClient sessionClient,
        IIngestionStreamSender streamSender,
        ICheckpointStore checkpointStore,
        IEventLogger<SendDeudoresUseCase> logger)
    {
        _source = source;
        _sessionClient = sessionClient;
        _streamSender = streamSender;
        _checkpointStore = checkpointStore;
        _logger = logger;
    }

    public async Task ExecuteAsync(
        string token,
        FeBoxDataLoad box,
        CancellationToken cancellationToken = default)
    {
        try
        {
            // 1️⃣ Crear sesión de ingestión
            var session = await _sessionClient.CreateSessionAsync(
                idLoad: box.IdLoad,
                dataset: "deudores",
                token,
                cancellationToken);

            // 2️⃣ Recuperar último checkpoint
            var lastSequence = await _checkpointStore
                .GetLastSequenceAsync(session.SessionId, cancellationToken);

            // 3️⃣ Obtener snapshot completo de deudores
            var deudoresStream = _source
                .GetDataStreamAsync(box.IdLoadLocal, cancellationToken);

            // 4️⃣ Enviar datos por streaming
            await _streamSender.SendStreamAsync(
                session,
                deudoresStream,
                lastSequence,
                token,
                cancellationToken);

            // 5️⃣ Confirmar carga
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
            _logger.Error($"SendDeudores failed for idLoadLocal={idLoadLocal}.", ex);
            throw;
        }
    }
}
