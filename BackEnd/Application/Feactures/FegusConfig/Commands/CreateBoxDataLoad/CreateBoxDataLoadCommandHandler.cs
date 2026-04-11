using System;
using Application.Feactures.FegusConfig.CreateBoxDataLoad;
using Common.Share;
using Domain.Entities.FegusConfig;

namespace Application.Feactures.FegusConfig.Commands.CreateBoxDataLoad;

public sealed class CreateBoxDataLoadCommandHandler
    : ICommandHandler<CreateBoxDataLoadCommand, long?>
{
    private readonly IBoxDataRepository _repository;

    public CreateBoxDataLoadCommandHandler(IBoxDataRepository repository)
    {
        _repository = repository;
    }

    public async Task<Result<long?>> Handle(
        CreateBoxDataLoadCommand request,
        CancellationToken cancellationToken)
    {
        var entity = new FeBoxDataLoad
        {
            IdCliente = request.IdCliente,
            StateCode = request.StateCode,
            IsActive = request.IsActive,
            AsofDate = request.AsofDate,
            CreatedAtUtc = DateTime.UtcNow
        };

        // Con ExecutionResult tenemos la estructura para traer error tipo BD
        ExecutionResult<long?> result = await _repository.AddFeBoxDataLoadAsync(entity, cancellationToken);

        if (result.SqlCode != 0)
        {
            //Con Result<T> tenemos la estructura para traer el error tipo técnico a devolver al API
            return Result<long?>.Fail(result.SqlMessage!, ErrorType.Technical);
        }

        return Result<long?>.Success(result.Data);
       
    }
}
