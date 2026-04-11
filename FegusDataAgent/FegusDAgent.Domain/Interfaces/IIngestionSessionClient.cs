using System;
using FegusDAgent.Domain.Values;

namespace FegusDAgent.Domain.Interfaces;

public interface IIngestionSessionClient
{
    Task<IngestionSession> CreateSessionAsync(
        int? idLoad, 
        string dataset,
        string token,
        CancellationToken cancellationToken);

    Task CommitAsync(
        string sessionId,
        string token,
        CancellationToken cancellationToken);

    Task<IngestionSessionStatus> GetStatusAsync(
        string sessionId,
        string token,
        CancellationToken cancellationToken);
}