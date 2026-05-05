namespace FegusDAgent.Domain.Entities;

public class GarantiaValor
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdGarantiaValor { get; private set; } = null!;

    // 📋 Clasificación del instrumento
    public string TipoClasificacionInstrumento { get; private set; } = null!;
    public string IdInstrumento { get; private set; } = null!;
    public string? SerieInstrumento { get; private set; }
    public string CodigoIsin { get; private set; } = null!;
    public string TipoAsignacionCalificacion { get; private set; } = null!;
    public string? CategoriaCalificacion { get; private set; }
    public string? CodigoCalificacionRiesgo { get; private set; }
    public string? CodigoEmpresaCalificadora { get; private set; }
    public string TipoColateralFinanciero { get; private set; } = null!;
    public string CodigoCalificacionInstrumento { get; private set; } = null!;

    // 👤 Emisor (nullable)
    public string? TipoPersona { get; private set; }
    public string? IdEmisor { get; private set; }

    // 💰 Valores
    public decimal? Premio { get; private set; }
    public decimal? ValorFacial { get; private set; }
    public string? TipoMonedaValorFacial { get; private set; }
    public decimal ValorMercado { get; private set; }
    public string? TipoMonedaValorMercado { get; private set; }
    public decimal PorcentajeAjusteRc { get; private set; }

    // 📅 Fechas
    public DateTime FechaConstitucion { get; private set; }
    public DateTime? FechaVencimiento { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private GarantiaValor() { }

    // 🏗️ Factory Method
    public static GarantiaValor Create(
        long idLoadLocal,
        string idGarantiaValor,
        string tipoClasificacionInstrumento,
        string? tipoPersona,
        string? idEmisor,
        string idInstrumento,
        string? serieInstrumento,
        decimal? premio,
        string codigoIsin,
        string tipoAsignacionCalificacion,
        string? categoriaCalificacion,
        string? codigoCalificacionRiesgo,
        string? codigoEmpresaCalificadora,
        decimal? valorFacial,
        string? tipoMonedaValorFacial,
        decimal valorMercado,
        string? tipoMonedaValorMercado,
        DateTime fechaConstitucion,
        DateTime? fechaVencimiento,
        string tipoColateralFinanciero,
        string codigoCalificacionInstrumento,
        decimal porcentajeAjusteRc)
    {
        return new GarantiaValor
        {
            IdLoadLocal = idLoadLocal,
            IdGarantiaValor = idGarantiaValor,
            TipoClasificacionInstrumento = tipoClasificacionInstrumento,
            TipoPersona = tipoPersona,
            IdEmisor = idEmisor,
            IdInstrumento = idInstrumento,
            SerieInstrumento = serieInstrumento,
            Premio = premio,
            CodigoIsin = codigoIsin,
            TipoAsignacionCalificacion = tipoAsignacionCalificacion,
            CategoriaCalificacion = categoriaCalificacion,
            CodigoCalificacionRiesgo = codigoCalificacionRiesgo,
            CodigoEmpresaCalificadora = codigoEmpresaCalificadora,
            ValorFacial = valorFacial,
            TipoMonedaValorFacial = tipoMonedaValorFacial,
            ValorMercado = valorMercado,
            TipoMonedaValorMercado = tipoMonedaValorMercado,
            FechaConstitucion = fechaConstitucion,
            FechaVencimiento = fechaVencimiento,
            TipoColateralFinanciero = tipoColateralFinanciero,
            CodigoCalificacionInstrumento = codigoCalificacionInstrumento,
            PorcentajeAjusteRc = porcentajeAjusteRc,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateValores(
        decimal nuevoValorMercado,
        decimal nuevoValorFacial,
        decimal nuevoPorcentajeAjuste)
    {
        ValorMercado = nuevoValorMercado;
        ValorFacial = nuevoValorFacial;
        PorcentajeAjusteRc = nuevoPorcentajeAjuste;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}
