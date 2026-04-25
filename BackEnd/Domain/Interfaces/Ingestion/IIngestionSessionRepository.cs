using System;
using Domain.Entities.Ingestion;

namespace Domain.Interfaces.Ingestion;

public interface IIngestionSessionRepository
{
    Task<IngestionSession> AddAsync(
        IngestionSession session,
        CancellationToken cancellationToken);

    Task<IngestionSession?> GetByIdAsync(
        Guid sessionId,
        CancellationToken cancellationToken);

    Task UpdateAsync(
        IngestionSession session,
        CancellationToken cancellationToken);

    /// <summary>
    /// Returns the most recent CREATED or RECEIVING session for the given
    /// (idCliente, idLoad, dataset) tuple, or null if none exists. Used by
    /// the agent to resume an interrupted ingestion run instead of creating
    /// a duplicate session.
    /// </summary>
    Task<IngestionSession?> GetInFlightByBoxAsync(
        int idCliente,
        int idLoad,
        string dataset,
        CancellationToken cancellationToken);

    /// <summary>
    /// Marks every session in CREATED or RECEIVING state whose created_at_utc
    /// is older than (NOW - olderThan) as FAILED. Returns the number of rows
    /// affected. Used by the orphan-session reaper background service.
    /// </summary>
    Task<int> ReapOrphanSessionsAsync(
        TimeSpan olderThan,
        CancellationToken cancellationToken);
}
