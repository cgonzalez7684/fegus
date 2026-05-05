namespace FegusDAgent.Domain.Entities;

public class GarantiaPoliza
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdGarantia { get; private set; } = null!;

    // 📋 Clasificación
    public string TipoGarantia { get; private set; } = null!;
    public string TipoBienGarantia { get; private set; } = null!;
    public string TipoPoliza { get; private set; } = null!;
    public string IndicadorCoberturasPoliza { get; private set; } = null!;

    // 💰 Monto
    public decimal MontoPoliza { get; private set; }

    // 📅 Fechas
    public DateTime FechaVencimientoPoliza { get; private set; }

    // 👤 Beneficiario
    public string TipoPersonaBeneficiario { get; private set; } = null!;
    public string IdBeneficiario { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private GarantiaPoliza() { }

    // 🏗️ Factory Method
    public static GarantiaPoliza Create(
        long idLoadLocal,
        string idGarantia,
        string tipoGarantia,
        string tipoBienGarantia,
        string tipoPoliza,
        decimal montoPoliza,
        DateTime fechaVencimientoPoliza,
        string indicadorCoberturasPoliza,
        string tipoPersonaBeneficiario,
        string idBeneficiario)
    {
        return new GarantiaPoliza
        {
            IdLoadLocal = idLoadLocal,
            IdGarantia = idGarantia,
            TipoGarantia = tipoGarantia,
            TipoBienGarantia = tipoBienGarantia,
            TipoPoliza = tipoPoliza,
            MontoPoliza = montoPoliza,
            FechaVencimientoPoliza = fechaVencimientoPoliza,
            IndicadorCoberturasPoliza = indicadorCoberturasPoliza,
            TipoPersonaBeneficiario = tipoPersonaBeneficiario,
            IdBeneficiario = idBeneficiario,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateMonto(decimal nuevoMontoPoliza)
    {
        MontoPoliza = nuevoMontoPoliza;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}
