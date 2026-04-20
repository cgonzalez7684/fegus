using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.FegusLocal;

public sealed class CreateBoxDataLoadLocalUseCase
{
    private readonly IFegusLocalRepository _repository;

    public CreateBoxDataLoadLocalUseCase(IFegusLocalRepository repository)
    {
        _repository = repository;
    }

    public Task<FeBoxDataLoad> ExecuteAsync(
        FeBoxDataLoad feBoxDataLoad,
        CancellationToken cancellationToken = default)
        => _repository.CreateBoxDataLoadLocal(feBoxDataLoad, cancellationToken);
}
