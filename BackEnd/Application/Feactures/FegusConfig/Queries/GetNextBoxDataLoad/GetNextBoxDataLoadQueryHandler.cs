using Common.Share;
using Domain.Entities.FegusConfig;

namespace Application.Feactures.FegusConfig.Queries.GetNextBoxDataLoad;

public sealed class GetNextBoxDataLoadQueryHandler
    : IQueryHandler<GetNextBoxDataLoadQuery, FeBoxDataLoad>
{
    private readonly IBoxDataRepository _repository;

    public GetNextBoxDataLoadQueryHandler(IBoxDataRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<FeBoxDataLoad>> Handle(
        GetNextBoxDataLoadQuery request,
        CancellationToken cancellationToken)
    {
        ExecutionResult<FeBoxDataLoad> result =
            await _repository.GetNexFeBoxDataLoadAsync(
                request.IdCliente,                
                cancellationToken);

        if (result.SqlCode != 0)
        {
            return Result<FeBoxDataLoad>
                .Fail(result.SqlMessage!, ErrorType.Technical);
        }

        return Result<FeBoxDataLoad>
            .Success(result.Data ?? new FeBoxDataLoad());
    }
}