using FegusDAgent.Domain.Entities;
using FegusDAgent.Domain.Interfaces;

namespace FegusDAgent.Application.UseCases.Fegus;

public sealed class GetNextBoxDataLoadUseCase(IFegusConfigClient fegusConfigClient)
{
    public async Task<FeBoxDataLoad?> ExecuteAsync(
        int idCliente,
        CancellationToken cancellationToken = default)
    {
        return await fegusConfigClient.GetNextBoxDataLoadAsync(idCliente, cancellationToken);
    }
}
