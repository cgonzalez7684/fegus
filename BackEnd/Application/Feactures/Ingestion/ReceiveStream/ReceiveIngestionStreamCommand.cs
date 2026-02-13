using System;

namespace Application.Feactures.Ingestion.ReceiveStream;

public sealed record ReceiveIngestionStreamCommand(
    Guid SessionId,
    Stream DataStream
) : ICommand;
