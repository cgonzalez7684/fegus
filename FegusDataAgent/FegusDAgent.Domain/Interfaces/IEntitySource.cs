using FegusDAgent.Domain.Values;

namespace FegusDAgent.Domain.Interfaces;

public interface IEntitySource<T>
{
    IAsyncEnumerable<SourceRecord<T>> GetDataStreamAsync(
        int? idCliente,
        long? idLoadLocal,
        long lastSeq,
        CancellationToken cancellationToken);
}
