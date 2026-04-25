using Common.Share;
using Domain.Entities.Ingestion;
using Domain.Interfaces.Ingestion;

namespace Application.Feactures.Ingestion.Queries;

public sealed class GetInFlightIngestionSessionQueryHandler
    : IQueryHandler<GetInFlightIngestionSessionQuery, IngestionSession?>
{
    private readonly IIngestionSessionRepository _repository;

    public GetInFlightIngestionSessionQueryHandler(
        IIngestionSessionRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<IngestionSession?>> Handle(
        GetInFlightIngestionSessionQuery query,
        CancellationToken cancellationToken)
    {
        var session = await _repository.GetInFlightByBoxAsync(
            query.IdCliente,
            query.IdLoad,
            query.Dataset,
            cancellationToken);

        return Result<IngestionSession?>.Success(session);
    }
}
