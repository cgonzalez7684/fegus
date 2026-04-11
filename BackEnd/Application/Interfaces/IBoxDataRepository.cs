
using Common.Share;
using Domain.Entities.FegusConfig;

namespace Application.Interfaces;

public interface IBoxDataRepository
{
    Task<ExecutionResult<long?>> AddFeBoxDataLoadAsync(FeBoxDataLoad dataLoad, CancellationToken ct);
    Task<ExecutionResult<bool>> UpdateFeBoxDataLoadAsync(FeBoxDataLoad dataLoad, CancellationToken ct);
    Task<ExecutionResult<bool>> DeleteFeBoxDataLoadAsync(int idCliente, long idLoad, CancellationToken ct);
    Task<ExecutionResult<IEnumerable<FeBoxDataLoad>>> GetFeBoxDataLoadAsync(int idCliente, long? idLoad, CancellationToken ct);

    Task<ExecutionResult<FeBoxDataLoad>> GetNexFeBoxDataLoadAsync(int idCliente,CancellationToken cancellationToken);
}
