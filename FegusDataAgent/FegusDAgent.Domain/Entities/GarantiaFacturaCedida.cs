namespace FegusDAgent.Domain.Entities;

public class GarantiaFacturaCedida
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdGarantiaFacturaCedida { get; private set; } = null!;

    // 👤 Obligado
    public string TipoPersona { get; private set; } = null!;
    public string IdObligado { get; private set; } = null!;

    // 💰 Valores
    public decimal ValorNominalGarantia { get; private set; }
    public string TipoMonedaValorNominal { get; private set; } = null!;
    public decimal PorcentajeAjusteRc { get; private set; }

    // 📅 Fechas
    public DateTime FechaConstitucion { get; private set; }
    public DateTime? FechaVencimiento { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private GarantiaFacturaCedida() { }

    // 🏗️ Factory Method
    public static GarantiaFacturaCedida Create(
        long idLoadLocal,
        string idGarantiaFacturaCedida,
        DateTime fechaConstitucion,
        DateTime? fechaVencimiento,
        string tipoPersona,
        string idObligado,
        decimal valorNominalGarantia,
        string tipoMonedaValorNominal,
        decimal porcentajeAjusteRc)
    {
        return new GarantiaFacturaCedida
        {
            IdLoadLocal = idLoadLocal,
            IdGarantiaFacturaCedida = idGarantiaFacturaCedida,
            FechaConstitucion = fechaConstitucion,
            FechaVencimiento = fechaVencimiento,
            TipoPersona = tipoPersona,
            IdObligado = idObligado,
            ValorNominalGarantia = valorNominalGarantia,
            TipoMonedaValorNominal = tipoMonedaValorNominal,
            PorcentajeAjusteRc = porcentajeAjusteRc,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateValores(decimal nuevoValorNominal, decimal nuevoPorcentajeAjuste)
    {
        ValorNominalGarantia = nuevoValorNominal;
        PorcentajeAjusteRc = nuevoPorcentajeAjuste;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}
