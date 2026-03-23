namespace FegusDAgent.Domain.Entities;

public class NaturalezaGasto
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string TipoNaturalezaGasto { get; private set; } = null!;

    // 📊 Porcentaje
    public decimal PorcentajeNaturalezaGasto { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private NaturalezaGasto() { }

    // 🏗️ Factory Method
    public static NaturalezaGasto Create(
        long idLoadLocal,
        string idOperacionCredito,
        string tipoNaturalezaGasto,
        decimal porcentajeNaturalezaGasto)
    {
        return new NaturalezaGasto
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoNaturalezaGasto = tipoNaturalezaGasto,
            PorcentajeNaturalezaGasto = porcentajeNaturalezaGasto,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdatePorcentaje(decimal nuevoPorcentaje)
    {
        PorcentajeNaturalezaGasto = nuevoPorcentaje;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}