using FegusDAgent.Application.Logging;
using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Enums;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Ingestion;

public sealed class SendGarantiasOperacionUseCase
{
    private readonly IEntitySource<GarantiaOperacion> _source;
    private readonly IIngestionSessionClient _sessionClient;
    private readonly IIngestionStreamSender _streamSender;
    private readonly IEventLogger<SendGarantiasOperacionUseCase> _logger;

    public SendGarantiasOperacionUseCase(
        IEntitySource<GarantiaOperacion> source,
        IIngestionSessionClient sessionClient,
        IIngestionStreamSender streamSender,
        IEventLogger<SendGarantiasOperacionUseCase> logger)
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
            var dataset = DataSetNameIngestion.GarantiasOperacion.ToString();

            var session = await _sessionClient.GetInFlightSessionAsync(
                              box.IdLoad, dataset, token, cancellationToken)
                          ?? await _sessionClient.CreateSessionAsync(
                              box.IdLoad, dataset, token, cancellationToken);

            _logger.Info($"SendGarantiasOperacion using sessionId={session.SessionId} state={session.SessionStateCode} for idLoad={box.IdLoad}.");

            var sessionStatus = await _sessionClient.GetStatusAsync(
                session.SessionId, token, cancellationToken);

            var lastSequence = sessionStatus.LastSequencePersisted;

            var dataStream = _source.GetDataStreamAsync(box.IdCliente, box.IdLoadLocal, cancellationToken);

            await _streamSender.SendStreamAsync(session, dataStream, lastSequence, token, cancellationToken);

            await _sessionClient.CommitAsync(session.SessionId, token, cancellationToken);
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            throw;
        }
        catch (Exception ex)
        {
            _logger.Error($"SendGarantiasOperacion failed for idLoadLocal={box.IdLoadLocal}.", ex);
            throw;
        }
    }
}
