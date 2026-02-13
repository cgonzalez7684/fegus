using System;

namespace FegusDAgent.Domain.Interfaces;

public interface ICheckpointStore
{
    Task<long> GetLastSequenceAsync(
        string sessionId,
        CancellationToken cancellationToken);

    Task SaveSequenceAsync(
        string sessionId,
        long sequence,
        CancellationToken cancellationToken);
}

