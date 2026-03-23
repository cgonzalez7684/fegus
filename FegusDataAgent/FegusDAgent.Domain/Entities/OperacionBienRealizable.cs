namespace FegusDAgent.Domain.Entities;

public class OperacionBienRealizable
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string TipoPersonaDeudor { get; private set; } = null!;
    public string IdDeudor { get; private set; } = null!;
    public string IdOperacionCredito { get; private set; } = null!;
    public string IdBienRealizable { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private OperacionBienRealizable() { }

    // 🏗️ Factory Method
    public static OperacionBienRealizable Create(
        long idLoadLocal,
        string tipoPersonaDeudor,
        string idDeudor,
        string idOperacionCredito,
        string idBienRealizable)
    {
        return new OperacionBienRealizable
        {
            IdLoadLocal = idLoadLocal,
            TipoPersonaDeudor = tipoPersonaDeudor,
            IdDeudor = idDeudor,
            IdOperacionCredito = idOperacionCredito,
            IdBienRealizable = idBienRealizable,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización (por si se requiere cambiar relación)
    public void UpdateOperacion(string nuevaOperacionCredito)
    {
        IdOperacionCredito = nuevaOperacionCredito;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}