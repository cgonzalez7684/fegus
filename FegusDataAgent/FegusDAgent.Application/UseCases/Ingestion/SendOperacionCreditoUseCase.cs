using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Enums;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Ingestion;

/// <summary>
/// Orquesta lectura de operaciones de crédito desde el origen local y envío al API de ingestión por streaming.
/// </summary>
public sealed class SendOperacionCreditoUseCase
{
    
    private readonly IEntitySource<OperacionCredito> _source;
    private readonly IIngestionSessionClient _sessionClient;
    private readonly IIngestionStreamSender _streamSender;    
    private readonly IEventLogger<SendOperacionCreditoUseCase> _logger;

    public SendOperacionCreditoUseCase(
        IEntitySource<OperacionCredito> source,
        IIngestionSessionClient sessionClient,
        IIngestionStreamSender streamSender,        
        IEventLogger<SendOperacionCreditoUseCase> logger)
    {
        _source = source;
        _sessionClient = sessionClient;
        _streamSender = streamSender;        
        _logger = logger;
    }

    public async Task ExecuteAsync(
        string token,
        FeBoxDataLoad box,
        CancellationToken cancellationToken = default)
    {
        try
        {
            var dataset = DataSetNameIngestion.OperacionesCredito.ToString();

            // 1️⃣ Reutilizar sesión en curso si existe (resume real); si no, crear una nueva.
            var session = await _sessionClient.GetInFlightSessionAsync(
                              box.IdLoad, dataset, token, cancellationToken)
                          ?? await _sessionClient.CreateSessionAsync(
                              box.IdLoad, dataset, token, cancellationToken);

            _logger.Info($"SendOperacionCredito using sessionId={session.SessionId} state={session.SessionStateCode} for idLoad={box.IdLoad}.");

            // 2️⃣ Recuperar último checkpoint desde la sesión remota
            var sessionStatus = await _sessionClient.GetStatusAsync(
                session.SessionId,
                token,
                cancellationToken);

            var lastSequence = sessionStatus.LastSequencePersisted;

            // 3️⃣ Obtener snapshot completo de deudores, esto no es un API
            //     es la ejecucion local de la funcion de pgsql que obtiene los datos de deudores para el idLoadLocal dado. El resultado se devuelve como un stream asincrono.
            var operacionCreditosStream = _source
                .GetDataStreamAsync(box.IdCliente, box.IdLoadLocal, cancellationToken);
            

            // 4️⃣ Enviar datos por streaming
            await _streamSender.SendStreamAsync(
                session,
                operacionCreditosStream,
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
            _logger.Error($"SendOperacionCredito failed for idLoadLocal={box.IdLoadLocal}.", ex);
            throw;
        }
    }
}
