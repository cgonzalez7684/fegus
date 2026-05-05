namespace FegusDAgent.Domain.Entities;

public class GarantiaCartaCredito
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdGarantiaCartaCredito { get; private set; } = null!;

    // 📋 Clasificación
    public string TipoMitigadorCartaCredito { get; private set; } = null!;
    public string TipoPersona { get; private set; } = null!;
    public string IdentidadCartaCredito { get; private set; } = null!;
    public string TipoAsignacionCalificacion { get; private set; } = null!;
    public string CodigoCalificacionCategoria { get; private set; } = null!;

    // 💰 Valores
    public decimal ValorNominalGarantia { get; private set; }
    public string TipoMonedaValorNominal { get; private set; } = null!;
    public decimal FactorY { get; private set; }

    // 📅 Fechas
    public DateTime FechaConstitucion { get; private set; }
    public DateTime? FechaVencimiento { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private GarantiaCartaCredito() { }

    // 🏗️ Factory Method
    public static GarantiaCartaCredito Create(
        long idLoadLocal,
        string idGarantiaCartaCredito,
        string tipoMitigadorCartaCredito,
        DateTime fechaConstitucion,
        DateTime? fechaVencimiento,
        string tipoPersona,
        string identidadCartaCredito,
        decimal valorNominalGarantia,
        string tipoMonedaValorNominal,
        string tipoAsignacionCalificacion,
        string codigoCalificacionCategoria,
        decimal factorY)
    {
        return new GarantiaCartaCredito
        {
            IdLoadLocal = idLoadLocal,
            IdGarantiaCartaCredito = idGarantiaCartaCredito,
            TipoMitigadorCartaCredito = tipoMitigadorCartaCredito,
            FechaConstitucion = fechaConstitucion,
            FechaVencimiento = fechaVencimiento,
            TipoPersona = tipoPersona,
            IdentidadCartaCredito = identidadCartaCredito,
            ValorNominalGarantia = valorNominalGarantia,
            TipoMonedaValorNominal = tipoMonedaValorNominal,
            TipoAsignacionCalificacion = tipoAsignacionCalificacion,
            CodigoCalificacionCategoria = codigoCalificacionCategoria,
            FactorY = factorY,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateValores(decimal nuevoValorNominal, decimal nuevoFactorY)
    {
        ValorNominalGarantia = nuevoValorNominal;
        FactorY = nuevoFactorY;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}
