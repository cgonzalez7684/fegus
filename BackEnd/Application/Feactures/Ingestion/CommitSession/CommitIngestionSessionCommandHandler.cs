using System;
using Common.Share;
using Domain.Interfaces.Ingestion;

namespace Application.Feactures.Ingestion.CommitSession;

public sealed class CommitIngestionSessionCommandHandler
    : ICommandHandler<CommitIngestionSessionCommand>
{
    private readonly IIngestionSessionRepository _repository;

    public CommitIngestionSessionCommandHandler(
        IIngestionSessionRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result> Handle(
        CommitIngestionSessionCommand command,
        CancellationToken cancellationToken)
    {
        var session = await _repository.GetByIdAsync(
            command.SessionId,
            cancellationToken);

        if (session is null)
            return Result.Fail(
                $"Ingestion session '{command.SessionId}' was not found.",
                ErrorType.NotFound);

        session.MarkCompleted();

        await _repository.UpdateAsync(session, cancellationToken);

        return Result.Success();
    }
}
