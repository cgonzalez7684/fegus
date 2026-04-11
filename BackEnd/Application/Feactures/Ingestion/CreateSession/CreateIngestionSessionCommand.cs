using System;

namespace Application.Feactures.Ingestion.CreateSession;

public sealed record CreateIngestionSessionCommand(
    int IdCliente,
    int IdLoad,
    string Dataset
) : ICommand<Guid>;