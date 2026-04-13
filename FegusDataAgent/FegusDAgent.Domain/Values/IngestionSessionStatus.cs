namespace FegusDAgent.Domain.Values;
public sealed record IngestionSessionStatus(
    Guid SessionId,
    int idCliente,
    long idLoad,
    string Dataset,
    string SessionStateCode,
    long LastSequencePersisted
    );
