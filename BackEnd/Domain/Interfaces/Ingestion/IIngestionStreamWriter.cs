using System;
using Domain.Entities.Ingestion;

namespace Domain.Interfaces.Ingestion;

public interface IIngestionStreamWriter
{
    Task WriteAsync(
        IngestionSession session,
        Stream stream,
        CancellationToken cancellationToken);
}