namespace Application.Interfaces;

public sealed record DatasetLoadResult(string Dataset, int Qty, string SqlCode, string SqlMessage);

public interface ILoadingRepository
{
    Task<IReadOnlyList<(int IdCliente, long IdLoad)>> GetBoxesReadyForLoadingAsync(CancellationToken ct);
    Task<IReadOnlyList<DatasetLoadResult>> LoadAllDatasetsAsync(int idCliente, long idLoad, CancellationToken ct);
}
