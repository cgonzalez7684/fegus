using Common.Share;
using Domain.Entities.FegusConfig;

namespace Application.Feactures.FegusConfig.Commands.UpdateBoxDataLoad;

public sealed class UpdateBoxDataLoadCommandHandler
    : ICommandHandler<UpdateBoxDataLoadCommand, bool>
{
    private readonly IBoxDataRepository _repository;

    public UpdateBoxDataLoadCommandHandler(IBoxDataRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<bool>> Handle(
        UpdateBoxDataLoadCommand request,
        CancellationToken cancellationToken)
    {        
        ExecutionResult<bool> result =
            await _repository.UpdateFeBoxDataLoadAsync(request.pFeBoxDataLoad, cancellationToken);

        if (result.SqlCode != 0)
        {
            return Result<bool>.Fail(result.SqlMessage!, ErrorType.Technical);
        }

        return Result<bool>.Success(result.Data);
    }
}