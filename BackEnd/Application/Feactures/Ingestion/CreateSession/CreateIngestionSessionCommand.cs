using System;

namespace Application.Feactures.Ingestion.CreateSession;

public sealed record CreateIngestionSessionCommand(
    int IdCliente,
    string Dataset
) : ICommand<Guid>;