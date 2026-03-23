namespace FegusDAgent.Domain.Entities;

public class OperacionNoReportada
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacion { get; private set; } = null!;

    // 👤 Deudor
    public string TipoPersona { get; private set; } = null!;
    public string IdDeudor { get; private set; } = null!;

    // 📌 Motivo de liquidación
    public string MotivoLiquidacion { get; private set; } = null!;

    // 📅 Fecha de liquidación
    public DateTime FechaLiquidacion { get; private set; }

    // 💰 Saldos liquidados
    public decimal SaldoPrincipalLiquidado { get; private set; }
    public decimal SaldoProductosLiquidado { get; private set; }

    // 🔗 Relación con nueva operación (nullable)
    public string? IdOperacionNueva { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private OperacionNoReportada() { }

    // 🏗️ Factory Method
    public static OperacionNoReportada Create(
        long idLoadLocal,
        string tipoPersona,
        string idDeudor,
        string idOperacion,
        string motivoLiquidacion,
        DateTime fechaLiquidacion,
        decimal saldoPrincipalLiquidado,
        decimal saldoProductosLiquidado,
        string? idOperacionNueva)
    {
        return new OperacionNoReportada
        {
            IdLoadLocal = idLoadLocal,
            TipoPersona = tipoPersona,
            IdDeudor = idDeudor,
            IdOperacion = idOperacion,
            MotivoLiquidacion = motivoLiquidacion,
            FechaLiquidacion = fechaLiquidacion,
            SaldoPrincipalLiquidado = saldoPrincipalLiquidado,
            SaldoProductosLiquidado = saldoProductosLiquidado,
            IdOperacionNueva = idOperacionNueva,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateSaldos(
        decimal nuevoSaldoPrincipal,
        decimal nuevoSaldoProductos)
    {
        SaldoPrincipalLiquidado = nuevoSaldoPrincipal;
        SaldoProductosLiquidado = nuevoSaldoProductos;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}