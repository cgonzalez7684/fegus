using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Fegus;

public sealed class UpdateFeBoxDataLoadUseCase(IFegusConfigClient fegusConfigClient)
{
    public async Task<bool> ExecuteAsync(
        string token,
        FeBoxDataLoad box,
        CancellationToken cancellationToken = default)
    {
        return await fegusConfigClient.UpdateFeBoxDataLoadAsync(token,box, cancellationToken);
    }
}
