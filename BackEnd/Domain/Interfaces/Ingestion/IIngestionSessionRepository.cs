using System;
using Domain.Entities.Ingestion;

namespace Domain.Interfaces.Ingestion;

public interface IIngestionSessionRepository
{
    Task AddAsync(
        IngestionSession session,
        CancellationToken cancellationToken);

    Task<IngestionSession?> GetByIdAsync(
        Guid sessionId,
        CancellationToken cancellationToken);

    Task UpdateAsync(
        IngestionSession session,
        CancellationToken cancellationToken);
}
