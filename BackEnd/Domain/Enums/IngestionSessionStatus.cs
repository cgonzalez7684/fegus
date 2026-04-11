namespace Domain.Enums;

public sealed class IngestionSessionStatus
{
    public string Value { get; }

    private IngestionSessionStatus(string value)
    {
        Value = value;
    }

    public static readonly IngestionSessionStatus Created = new("CREATED");
    public static readonly IngestionSessionStatus Receiving = new("RECEIVING");
    public static readonly IngestionSessionStatus Completed = new("COMPLETED");
    public static readonly IngestionSessionStatus Failed = new("FAILED");
    

    public override string ToString() => Value;
}
