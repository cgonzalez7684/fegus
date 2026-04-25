using Domain.Entities.Ingestion;

namespace Application.Feactures.Ingestion.Queries;

public sealed record GetInFlightIngestionSessionQuery(
    int IdCliente,
    int IdLoad,
    string Dataset
) : IQuery<IngestionSession?>;
