using System;
using Common.Share;
using Domain.Entities.Ingestion;
using Domain.Interfaces.Ingestion;

namespace Application.Feactures.Ingestion.Queries;

public sealed class GetIngestionSessionStatusQueryHandler
    : IQueryHandler<GetIngestionSessionStatusQuery, IngestionSession>
{
    private readonly IIngestionSessionRepository _repository;

    public GetIngestionSessionStatusQueryHandler(
        IIngestionSessionRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<IngestionSession>> Handle(
        GetIngestionSessionStatusQuery query,
        CancellationToken cancellationToken)
    {
        var session = await _repository.GetByIdAsync(
            query.SessionId,
            cancellationToken);

        if (session is null)
            return Result<IngestionSession>.Fail("Ingestion session not found", ErrorType.NotFound);

        return Result<IngestionSession>.Success(session);
    }
}
