using System;
using FegusDAgent.Domain.Values;

namespace FegusDAgent.Domain.Interfaces;

public interface IIngestionSessionClient
{
    Task<IngestionSession> CreateSessionAsync(
        string dataset,        
        CancellationToken cancellationToken);

    Task CommitAsync(
        string sessionId,
        CancellationToken cancellationToken);

    Task<IngestionSessionStatus> GetStatusAsync(
        string sessionId,
        CancellationToken cancellationToken);
}