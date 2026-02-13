using System;
using Domain.Entities.Ingestion;

namespace Application.Feactures.Ingestion.Queries;

public sealed record GetIngestionSessionStatusQuery(
    Guid SessionId
) : IQuery<IngestionSession>;
