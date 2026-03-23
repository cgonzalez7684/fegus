namespace Infrastructure.Persistence.Models;

public sealed class BoxInsertDbRawResult
{
    public long? Pidload { get; set; }
    public int? Psqlcode { get; set; }
    public string? Psqlmessage { get; set; }
    public int Pqty { get; set; }
}