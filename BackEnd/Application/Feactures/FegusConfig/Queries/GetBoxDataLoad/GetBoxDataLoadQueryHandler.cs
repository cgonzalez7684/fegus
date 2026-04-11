using Common.Share;
using Domain.Entities.FegusConfig;

namespace Application.Feactures.FegusConfig.Queries.GetBoxDataLoad;

public sealed class GetBoxDataLoadQueryHandler
    : IQueryHandler<GetBoxDataLoadQuery, IEnumerable<FeBoxDataLoad>>
{
    private readonly IBoxDataRepository _repository;

    public GetBoxDataLoadQueryHandler(IBoxDataRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<IEnumerable<FeBoxDataLoad>>> Handle(
        GetBoxDataLoadQuery request,
        CancellationToken cancellationToken)
    {
        ExecutionResult<IEnumerable<FeBoxDataLoad>> result =
            await _repository.GetFeBoxDataLoadAsync(
                request.IdCliente,
                request.IdLoad,
                cancellationToken);

        if (result.SqlCode != 0)
        {
            return Result<IEnumerable<FeBoxDataLoad>>
                .Fail(result.SqlMessage!, ErrorType.Technical);
        }

        return Result<IEnumerable<FeBoxDataLoad>>
            .Success(result.Data ?? Enumerable.Empty<FeBoxDataLoad>());
    }
}