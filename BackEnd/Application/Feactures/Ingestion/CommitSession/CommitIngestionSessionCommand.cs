using System;

namespace Application.Feactures.Ingestion.CommitSession;

public sealed record CommitIngestionSessionCommand(
    Guid SessionId
) : ICommand;
