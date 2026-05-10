using FegusDAgent.Domain.Values;

namespace FegusDAgent.Domain.Interfaces;

public interface IIngestionStreamSender
{
    Task SendStreamAsync<T>(
        IngestionSession session,
        IAsyncEnumerable<SourceRecord<T>> data,
        string token,
        CancellationToken cancellationToken);
}
