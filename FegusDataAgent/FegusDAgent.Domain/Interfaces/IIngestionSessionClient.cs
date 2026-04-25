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

    /// <summary>
    /// Returns the latest CREATED or RECEIVING session for a box+dataset, or <c>null</c>
    /// if none exists. Used to resume a previous run after a crash or transient failure.
    /// Returns <c>null</c> (rather than throwing) when the BackEnd endpoint is not deployed,
    /// so the agent can ship before the BackEnd half of the change.
    /// </summary>
    Task<IngestionSession?> GetInFlightSessionAsync(
        int? idLoad,
        string dataset,
        string token,
        CancellationToken cancellationToken);
}