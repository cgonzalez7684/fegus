namespace FegusDAgent.Domain.Values;
public sealed record IngestionSession(
    int IdCliente,
    int IdLoad,
    Guid SessionId,
    string? Dataset,
    string? SessionStateCode,
    long LastSequencePersisted,
    DateTime CreatedAtUtc,
    DateTime UpdatedAtUtc,
    string? ErrorMessage    
);
