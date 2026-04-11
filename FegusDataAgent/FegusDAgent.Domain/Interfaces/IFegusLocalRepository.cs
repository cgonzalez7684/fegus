using FegusDAgent.Domain.Entities;

namespace FegusDAgent.Domain.Interfaces;

public interface IFegusLocalRepository
{
    Task<FeBoxDataLoad> CreateBoxDataLoadLocal(FeBoxDataLoad dataLoad, CancellationToken cancellationToken);
}
