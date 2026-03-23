namespace FegusDAgent.Domain.Entities;

public class IngresoDeudor
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string TipoPersonaDeudor { get; private set; } = null!;
    public string IdDeudor { get; private set; } = null!;
    public string TipoIngresoDeudor { get; private set; } = null!;
    public string TipoMonedaIngreso { get; private set; } = null!;

    // 💰 Monto
    public decimal MontoIngresoDeudor { get; private set; }

    // 📅 Fecha de verificación (nullable)
    public DateTime? FechaVerificacionIngreso { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private IngresoDeudor() { }

    // 🏗️ Factory Method
    public static IngresoDeudor Create(
        long idLoadLocal,
        string tipoPersonaDeudor,
        string idDeudor,
        string tipoIngresoDeudor,
        decimal montoIngresoDeudor,
        string tipoMonedaIngreso,
        DateTime? fechaVerificacionIngreso)
    {
        return new IngresoDeudor
        {
            IdLoadLocal = idLoadLocal,
            TipoPersonaDeudor = tipoPersonaDeudor,
            IdDeudor = idDeudor,
            TipoIngresoDeudor = tipoIngresoDeudor,
            MontoIngresoDeudor = montoIngresoDeudor,
            TipoMonedaIngreso = tipoMonedaIngreso,
            FechaVerificacionIngreso = fechaVerificacionIngreso,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateMonto(decimal nuevoMontoIngreso)
    {
        MontoIngresoDeudor = nuevoMontoIngreso;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}