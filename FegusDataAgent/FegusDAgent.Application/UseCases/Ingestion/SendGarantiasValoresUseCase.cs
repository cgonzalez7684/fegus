using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Enums;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Ingestion;

public sealed class SendGarantiasValoresUseCase
{
    private readonly IEntitySource<GarantiaValor> _source;
    private readonly IIngestionSessionClient _sessionClient;
    private readonly IIngestionStreamSender _streamSender;
    private readonly IEventLogger<SendGarantiasValoresUseCase> _logger;

    public SendGarantiasValoresUseCase(
        IEntitySource<GarantiaValor> source,
        IIngestionSessionClient sessionClient,
        IIngestionStreamSender streamSender,
        IEventLogger<SendGarantiasValoresUseCase> logger)
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
            var dataset = DataSetNameIngestion.GarantiasValores.ToString();

            var session = await _sessionClient.GetInFlightSessionAsync(
                              box.IdLoad, dataset, token, cancellationToken)
                          ?? await _sessionClient.CreateSessionAsync(
                              box.IdLoad, dataset, token, cancellationToken);

            if (string.Equals(session.SessionStateCode, "COMPLETED", StringComparison.OrdinalIgnoreCase))
            {
                _logger.Info($"Dataset {dataset} already COMPLETED for idLoad={box.IdLoad}. Skipping duplicate load.");
                return;
            }

            var sessionStatus = await _sessionClient.GetStatusAsync(
                session.SessionId, token, cancellationToken);

            var lastSequence = sessionStatus.LastSequencePersisted;

            _logger.Info($"SendGarantiasValores using sessionId={session.SessionId} state={session.SessionStateCode} for idLoad={box.IdLoad} for idLoadLocal={box.IdLoadLocal} lastSequence={lastSequence}.");

            var dataStream = _source.GetDataStreamAsync(box.IdCliente, box.IdLoadLocal, lastSequence, cancellationToken);

            await _streamSender.SendStreamAsync(session, dataStream, token, cancellationToken);

            await _sessionClient.CommitAsync(session.SessionId, token, cancellationToken);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.Error($"SendGarantiasValores failed for idLoadLocal={box.IdLoadLocal}.", ex);
            throw;
        }
    }
}
