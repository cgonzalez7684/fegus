using System;
using FegusDAgent.Domain.Values;

namespace FegusDAgent.Domain.Interfaces;

public interface IIngestionStreamSender
{
    Task StreamAsync<T>(
        IngestionSession session,
        IAsyncEnumerable<T> data,
        long startSequence,
        CancellationToken cancellationToken);
}
