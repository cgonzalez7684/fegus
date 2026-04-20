using System;
using Common.Share;
using Domain.Interfaces.Ingestion;
using Microsoft.Extensions.Logging;

namespace Application.Feactures.Ingestion.ReceiveStream;

public sealed class ReceiveIngestionStreamCommandHandler
    : ICommandHandler<ReceiveIngestionStreamCommand>
{
    private readonly IIngestionSessionRepository _repository;
    private readonly IIngestionStreamWriter _streamWriter;
    private readonly ILogger<ReceiveIngestionStreamCommandHandler> _logger;

    public ReceiveIngestionStreamCommandHandler(
        IIngestionSessionRepository repository,
        IIngestionStreamWriter streamWriter,
        ILogger<ReceiveIngestionStreamCommandHandler> logger)
    {
        _repository = repository;
        _streamWriter = streamWriter;
        _logger = logger;
    }

    public async Task<Result> Handle(
        ReceiveIngestionStreamCommand command,
        CancellationToken cancellationToken)
    {
        var session = await _repository.GetByIdAsync(
            command.SessionId,
            cancellationToken);

        if (session is null)
            return Result.Fail(
                $"Ingestion session '{command.SessionId}' was not found.",
                ErrorType.NotFound);

        try
        {
            session.MarkReceiving();

            await _repository.UpdateAsync(session, cancellationToken);

            await _streamWriter.WriteAsync(
                session,
                command.DataStream,
                cancellationToken);

            await _repository.UpdateAsync(session, cancellationToken);

            return Result.Success();
        }
        catch (Exception ex)
        {
            _logger.LogError(ex,
                "Stream write failed for SessionId={SessionId} IdCliente={IdCliente}: {Message}",
                command.SessionId, session.IdCliente, ex.Message);

            session.MarkFailed();
            await _repository.UpdateAsync(session, cancellationToken);

            return Result.Fail(
                $"An error occurred while receiving ingestion stream: {ex.Message}",
                ErrorType.Technical);
        }
    }
}
