namespace FegusDAgent.Domain.Entities;

public class ActividadEconomica
{
    // 🔑 Primary Key (compuestass)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string TipoActividadEconomica { get; private set; } = null!;

    // 📊 Datos de negocio
    public decimal PorcentajeActividadEconomica { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado (DDD)
    private ActividadEconomica() { }

    // 🏗️ Factory method (recomendado en Domain)
    public static ActividadEconomica Create(
        long idLoadLocal,
        string idOperacionCredito,
        string tipoActividadEconomica,
        decimal porcentajeActividadEconomica)
    {
        return new ActividadEconomica
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoActividadEconomica = tipoActividadEconomica,
            PorcentajeActividadEconomica = porcentajeActividadEconomica,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdatePorcentaje(decimal nuevoPorcentaje)
    {
        PorcentajeActividadEconomica = nuevoPorcentaje;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}