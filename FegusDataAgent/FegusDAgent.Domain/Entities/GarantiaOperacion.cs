namespace FegusDAgent.Domain.Entities;

public class GarantiaOperacion
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string TipoPersonaDeudor { get; private set; } = null!;
    public string IdDeudor { get; private set; } = null!;
    public string IdGarantia { get; private set; } = null!;
    public string TipoMitigador { get; private set; } = null!;
    public string TipoDocumentoLegal { get; private set; } = null!;

    // 🔗 Información de la garantía
    public string TipoGarantia { get; private set; } = null!;
    public string IndicadorFormaTraspasoBien { get; private set; } = null!;
    public string IdGarantiaTraspaso { get; private set; } = null!;

    // 💰 Valores
    public decimal ValorAjustadoGarantia { get; private set; }
    public decimal PorcentajeResponsabilidadGarantia { get; private set; }
    public decimal ValorNominalGarantia { get; private set; }

    // 📚 Clasificación
    public string TipoInscripcionGarantia { get; private set; } = null!;

    // 💱 Moneda (nullable en BD)
    public string? TipoMonedaValorNominalGarantia { get; private set; }

    // 📅 Fechas (nullable según BD)
    public DateTime? FechaPresentacionRegistroGarantia { get; private set; }
    public DateTime? FechaConstitucionGarantia { get; private set; }
    public DateTime? FechaVencimientoGarantia { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private GarantiaOperacion() { }

    // 🏗️ Factory Method
    public static GarantiaOperacion Create(
        long idLoadLocal,
        string tipoPersonaDeudor,
        string idDeudor,
        string idOperacionCredito,
        string tipoGarantia,
        string idGarantia,
        string indicadorFormaTraspasoBien,
        string idGarantiaTraspaso,
        string tipoMitigador,
        string tipoDocumentoLegal,
        decimal valorAjustadoGarantia,
        string tipoInscripcionGarantia,
        decimal porcentajeResponsabilidadGarantia,
        decimal valorNominalGarantia,
        DateTime? fechaPresentacionRegistroGarantia,
        string? tipoMonedaValorNominalGarantia,
        DateTime? fechaConstitucionGarantia,
        DateTime? fechaVencimientoGarantia)
    {
        return new GarantiaOperacion
        {
            IdLoadLocal = idLoadLocal,
            TipoPersonaDeudor = tipoPersonaDeudor,
            IdDeudor = idDeudor,
            IdOperacionCredito = idOperacionCredito,
            TipoGarantia = tipoGarantia,
            IdGarantia = idGarantia,
            IndicadorFormaTraspasoBien = indicadorFormaTraspasoBien,
            IdGarantiaTraspaso = idGarantiaTraspaso,
            TipoMitigador = tipoMitigador,
            TipoDocumentoLegal = tipoDocumentoLegal,
            ValorAjustadoGarantia = valorAjustadoGarantia,
            TipoInscripcionGarantia = tipoInscripcionGarantia,
            PorcentajeResponsabilidadGarantia = porcentajeResponsabilidadGarantia,
            ValorNominalGarantia = valorNominalGarantia,
            FechaPresentacionRegistroGarantia = fechaPresentacionRegistroGarantia,
            TipoMonedaValorNominalGarantia = tipoMonedaValorNominalGarantia,
            FechaConstitucionGarantia = fechaConstitucionGarantia,
            FechaVencimientoGarantia = fechaVencimientoGarantia,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateValores(
        decimal nuevoValorAjustado,
        decimal nuevoValorNominal,
        decimal nuevoPorcentajeResponsabilidad)
    {
        ValorAjustadoGarantia = nuevoValorAjustado;
        ValorNominalGarantia = nuevoValorNominal;
        PorcentajeResponsabilidadGarantia = nuevoPorcentajeResponsabilidad;

        UpdatedAtUtc = DateTime.UtcNow;
    }
}