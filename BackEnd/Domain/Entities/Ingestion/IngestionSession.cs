using Domain.Enums;

namespace Domain.Entities.Ingestion;

public sealed class IngestionSession
{
    public int IdCliente { get; private set; }  
    public Guid SessionId { get; private set; }
    public string? Dataset { get; private set; }
    public int Status { get; private set; }
    public long LastSequencePersisted { get; private set; }
    public DateTime CreatedAtUtc { get; private set; }

    private IngestionSession() { }

    public IngestionSession(
        Guid sessionId,
        int idCliente,
        string dataset,
        int status,
        long lastSequencePersisted)
    {
        SessionId = sessionId;
        IdCliente = idCliente;
        Dataset = dataset;
        Status = status;
        LastSequencePersisted = lastSequencePersisted;
        CreatedAtUtc = DateTime.UtcNow;
    }

    public void MarkReceiving()
    {
        Status = (int)IngestionSessionStatus.Receiving;
    }

    public void UpdateLastSequence(long sequence)
    {
        if (sequence > LastSequencePersisted)
            LastSequencePersisted = sequence;
    }

    public void MarkCompleted()
    {
        Status = (int)IngestionSessionStatus.Completed;
    }

    public void MarkFailed()
    {
        Status = (int)IngestionSessionStatus.Failed;
    }
}

