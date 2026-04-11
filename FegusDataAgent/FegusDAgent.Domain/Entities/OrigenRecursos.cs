namespace FegusDAgent.Domain.Entities;

public class OrigenRecursos
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string TipoOrigenRecursos { get; private set; } = null!;

    // 📊 Porcentaje
    public decimal PorcentajeOrigenRecursos { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private OrigenRecursos() { }

    // 🏗️ Factory Method
    public static OrigenRecursos Create(
        long idLoadLocal,
        string idOperacionCredito,
        string tipoOrigenRecursos,
        decimal porcentajeOrigenRecursos)
    {
        return new OrigenRecursos
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoOrigenRecursos = tipoOrigenRecursos,
            PorcentajeOrigenRecursos = porcentajeOrigenRecursos,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdatePorcentaje(decimal nuevoPorcentaje)
    {
        PorcentajeOrigenRecursos = nuevoPorcentaje;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}