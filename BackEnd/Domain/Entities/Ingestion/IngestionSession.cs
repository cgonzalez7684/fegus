using Domain.Enums;

namespace Domain.Entities.Ingestion;

public sealed class IngestionSession
{
    public int IdCliente { get; private set; }  

    public int IdLoad { get; private set; }
    public Guid SessionId { get; private set; }
    public string? Dataset { get; private set; }
    public string? SessionStateCode { get; private set; }
    public long LastSequencePersisted { get; private set; }
    public DateTime CreatedAtUtc { get; private set; }

    public DateTime UpdatedAtUtc { get; private set; }

    public string? ErrorMessage { get; private set; }

    private IngestionSession() { }

    public IngestionSession(
        Guid sessionId,
        int idCliente,
        int idLoad,
        string dataset,
        string sessionStateCode,
        long lastSequencePersisted)
    {
        SessionId = sessionId;
        IdCliente = idCliente;
        IdLoad = idLoad;
        Dataset = dataset;
        SessionStateCode = sessionStateCode;
        LastSequencePersisted = lastSequencePersisted;
        CreatedAtUtc = DateTime.UtcNow;
    }

    public void MarkReceiving()
    {
        SessionStateCode = IngestionSessionStatus.Receiving.ToString();
    }

    public void UpdateLastSequence(long sequence)
    {
        if (sequence > LastSequencePersisted)
            LastSequencePersisted = sequence;
    }

    public void MarkCompleted()
    {
        SessionStateCode = IngestionSessionStatus.Completed.ToString();
    }

    public void MarkFailed()
    {
        SessionStateCode = IngestionSessionStatus.Failed.ToString();
    }
}

