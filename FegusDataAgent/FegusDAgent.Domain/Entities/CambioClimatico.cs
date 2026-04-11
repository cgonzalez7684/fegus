namespace FegusDAgent.Domain.Entities;

public class CambioClimatico
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;

    // 🌱 Clasificación climática / ESG
    public string TipoTema { get; private set; } = null!;
    public string TipoSubtema { get; private set; } = null!;
    public string TipoActividad { get; private set; } = null!;
    public string TipoAmbito { get; private set; } = null!;
    public string TipoFuenteFinanciamiento { get; private set; } = null!;
    public string TipoFondoFinanciamiento { get; private set; } = null!;

    // 💰 Monto climático
    public decimal SaldoMontoClimatico { get; private set; }

    // 🏷️ Modalidad
    public string CodigoModalidad { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private CambioClimatico() { }

    // 🏗️ Factory Method
    public static CambioClimatico Create(
        long idLoadLocal,
        string idOperacionCredito,
        string tipoTema,
        string tipoSubtema,
        string tipoActividad,
        string tipoAmbito,
        string tipoFuenteFinanciamiento,
        string tipoFondoFinanciamiento,
        decimal saldoMontoClimatico,
        string codigoModalidad)
    {
        return new CambioClimatico
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoTema = tipoTema,
            TipoSubtema = tipoSubtema,
            TipoActividad = tipoActividad,
            TipoAmbito = tipoAmbito,
            TipoFuenteFinanciamiento = tipoFuenteFinanciamiento,
            TipoFondoFinanciamiento = tipoFondoFinanciamiento,
            SaldoMontoClimatico = saldoMontoClimatico,
            CodigoModalidad = codigoModalidad,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateMonto(decimal nuevoSaldoMontoClimatico)
    {
        SaldoMontoClimatico = nuevoSaldoMontoClimatico;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}