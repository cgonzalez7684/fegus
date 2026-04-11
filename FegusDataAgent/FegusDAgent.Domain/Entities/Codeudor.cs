namespace FegusDAgent.Domain.Entities;

public class Codeudor
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string IdCodeudor { get; private set; } = null!;
    public string TipoPersonaCodeudor { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private Codeudor() { }

    // 🏗️ Factory Method
    public static Codeudor Create(
        long idLoadLocal,
        string idOperacionCredito,
        string idCodeudor,
        string tipoPersonaCodeudor)
    {
        return new Codeudor
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            IdCodeudor = idCodeudor,
            TipoPersonaCodeudor = tipoPersonaCodeudor,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización (si en algún momento cambia el tipo)
    public void UpdateTipoPersona(string nuevoTipoPersonaCodeudor)
    {
        TipoPersonaCodeudor = nuevoTipoPersonaCodeudor;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}