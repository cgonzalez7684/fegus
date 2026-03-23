using Common.Share;

namespace Application.Feactures.FegusConfig.Commands.DeleteBoxDataLoad;

public sealed class DeleteBoxDataLoadCommandHandler
    : ICommandHandler<DeleteBoxDataLoadCommand, bool>
{
    private readonly IBoxDataRepository _repository;

    public DeleteBoxDataLoadCommandHandler(IBoxDataRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<bool>> Handle(
        DeleteBoxDataLoadCommand request,
        CancellationToken cancellationToken)
    {
        ExecutionResult<bool> result =
            await _repository.DeleteFeBoxDataLoadAsync(
                request.IdCliente,
                request.IdLoad,
                cancellationToken);

        if (result.SqlCode != 0)
        {
            return Result<bool>.Fail(result.SqlMessage!, ErrorType.Technical);
        }

        return Result<bool>.Success(result.Data);
    }
}