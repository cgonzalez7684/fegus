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
        Guid sessionId,
        string token,
        CancellationToken cancellationToken);

    Task<IngestionSessionStatus> GetStatusAsync(
        Guid sessionId,
        string token,
        CancellationToken cancellationToken);
}