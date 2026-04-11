using System;
using FegusDAgent.Domain.Values;

namespace FegusDAgent.Domain.Interfaces;

public interface IIngestionStreamSender
{
    Task SendStreamAsync<T>(
        IngestionSession session,
        IAsyncEnumerable<T> data,
        long startSequence,
        string token,
        CancellationToken cancellationToken);
}
