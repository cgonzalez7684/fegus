using System;
using Common.Share;
using Domain.Interfaces.Ingestion;

namespace Application.Feactures.Ingestion.ReceiveStream;

public sealed class ReceiveIngestionStreamCommandHandler
    : ICommandHandler<ReceiveIngestionStreamCommand>
{
    private readonly IIngestionSessionRepository _repository;
    private readonly IIngestionStreamWriter _streamWriter;

    public ReceiveIngestionStreamCommandHandler(
        IIngestionSessionRepository repository,
        IIngestionStreamWriter streamWriter)
    {
        _repository = repository;
        _streamWriter = streamWriter;
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
            session.MarkFailed();
            await _repository.UpdateAsync(session, cancellationToken);

            return Result.Fail(
                $"An error occurred while receiving ingestion stream: {ex.Message}",
                ErrorType.Technical);
        }
    }
}
