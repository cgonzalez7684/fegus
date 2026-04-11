namespace FegusDAgent.Domain.Entities;

public class Gravamen
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string IdGarantia { get; private set; } = null!;
    public string TipoMitigador { get; private set; } = null!;
    public string TipoDocumentoLegal { get; private set; } = null!;
    public string TipoGradoGravamen { get; private set; } = null!;
    public string TipoPersonaAcreedor { get; private set; } = null!;
    public string IdAcreedor { get; private set; } = null!;

    // 💰 Información financiera
    public decimal MontoGradoGravamen { get; private set; }
    public string TipoMonedaMonto { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private Gravamen() { }

    // 🏗️ Factory Method
    public static Gravamen Create(
        long idLoadLocal,
        string idOperacionCredito,
        string idGarantia,
        string tipoMitigador,
        string tipoDocumentoLegal,
        string tipoGradoGravamen,
        string tipoPersonaAcreedor,
        string idAcreedor,
        decimal montoGradoGravamen,
        string tipoMonedaMonto)
    {
        return new Gravamen
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            IdGarantia = idGarantia,
            TipoMitigador = tipoMitigador,
            TipoDocumentoLegal = tipoDocumentoLegal,
            TipoGradoGravamen = tipoGradoGravamen,
            TipoPersonaAcreedor = tipoPersonaAcreedor,
            IdAcreedor = idAcreedor,
            MontoGradoGravamen = montoGradoGravamen,
            TipoMonedaMonto = tipoMonedaMonto,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateMonto(decimal nuevoMontoGravamen)
    {
        MontoGradoGravamen = nuevoMontoGravamen;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}