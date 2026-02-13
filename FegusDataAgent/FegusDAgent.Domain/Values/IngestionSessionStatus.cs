namespace FegusDAgent.Domain.Values;
public sealed record IngestionSessionStatus(
    string SessionId,
    long LastSequencePersisted,
    string Status);
