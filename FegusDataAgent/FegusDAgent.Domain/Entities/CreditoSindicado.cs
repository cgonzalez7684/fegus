namespace FegusDAgent.Domain.Entities;

public class CreditoSindicado
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string TipoPersona { get; private set; } = null!;
    public string IdentidadCreditoSindicado { get; private set; } = null!;
    public string IdOperacionCreditoEntidadCreditoSindicado { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private CreditoSindicado() { }

    // 🏗️ Factory Method
    public static CreditoSindicado Create(
        long idLoadLocal,
        string idOperacionCredito,
        string tipoPersona,
        string identidadCreditoSindicado,
        string idOperacionCreditoEntidadCreditoSindicado)
    {
        return new CreditoSindicado
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoPersona = tipoPersona,
            IdentidadCreditoSindicado = identidadCreditoSindicado,
            IdOperacionCreditoEntidadCreditoSindicado = idOperacionCreditoEntidadCreditoSindicado,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateRelacion(string nuevoIdOperacionCreditoEntidad)
    {
        IdOperacionCreditoEntidadCreditoSindicado = nuevoIdOperacionCreditoEntidad;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}