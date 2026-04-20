namespace Domain.Enums;
public sealed class DataSetNameIngestion
{
    public string Value { get; }

    private DataSetNameIngestion(string value)
    {
        Value = value;
    }

    public static readonly DataSetNameIngestion Deudores = new("Deudores");
    public static readonly DataSetNameIngestion OperacionesCredito = new("OperacionesCredito");
    public static readonly DataSetNameIngestion GarantiasOperacion = new("GarantiasOperacion");
       

    public override string ToString() => Value;
}
