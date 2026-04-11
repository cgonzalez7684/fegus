namespace FegusDAgent.Domain.Entities;

public class OperacionCredito
{
    // 🔑 Primary Key
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;

    // 👤 Deudor
    public int TipoPersonaDeudor { get; private set; }
    public string IdDeudor { get; private set; } = null!;

    // 📊 Clasificación
    public int TipoOperacionSFN { get; private set; }
    public int TipoOperacion { get; private set; }
    public int TipoCatalogoSugef { get; private set; }
    public int TipoCarteraCrediticia { get; private set; }

    // 📈 Riesgo
    public int? CodigoCategoriaRiesgo { get; private set; }
    public decimal? TasaIncumplimiento { get; private set; }
    public decimal? LGDPromedio { get; private set; }
    public decimal? LGDRegulatorio { get; private set; }

    // 💰 Montos principales
    public decimal MontoOperacionAutorizado { get; private set; }
    public decimal MontoDesembolsado { get; private set; }
    public decimal SaldoPrincipalOperacionCrediticia { get; private set; }
    public decimal SaldoProductosPorCobrar { get; private set; }
    public decimal EAD { get; private set; }

    // 💱 Moneda
    public int TipoMonedaOperacion { get; private set; }

    // 📅 Fechas
    public DateTime FechaFormalizacion { get; private set; }
    public DateTime FechaVencimiento { get; private set; }

    // ⏱️ Mora
    public int DiasMaximaMorosidad { get; private set; }

    // 📊 Cuotas
    public decimal? MontoCuotaPrincipalActual { get; private set; }
    public decimal? MontoCuotaInteresesActual { get; private set; }

    // 📈 Tasas
    public decimal? TasaInteresNominalVigente { get; private set; }
    public string? IndicadorTipoTasa { get; private set; }

    // 🏦 Indicadores
    public string IndicadorBackToBack { get; private set; } = null!;
    public string IndicadorCreditoSindicado { get; private set; } = null!;
    public string IndicadorOperacionEspecial { get; private set; } = null!;
    public string IndicadorCambioClimatico { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private OperacionCredito() { }

    // 🏗️ Factory Method
    public static OperacionCredito Create(
        long idLoadLocal,
        string idOperacionCredito,
        int tipoPersonaDeudor,
        string idDeudor,
        int tipoOperacionSFN,
        int tipoOperacion,
        int tipoCatalogoSugef,
        int tipoCarteraCrediticia,
        decimal montoOperacionAutorizado,
        decimal montoDesembolsado,
        decimal saldoPrincipal,
        decimal saldoProductos,
        decimal ead,
        int tipoMonedaOperacion,
        DateTime fechaFormalizacion,
        DateTime fechaVencimiento,
        int diasMaximaMorosidad)
    {
        return new OperacionCredito
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoPersonaDeudor = tipoPersonaDeudor,
            IdDeudor = idDeudor,
            TipoOperacionSFN = tipoOperacionSFN,
            TipoOperacion = tipoOperacion,
            TipoCatalogoSugef = tipoCatalogoSugef,
            TipoCarteraCrediticia = tipoCarteraCrediticia,
            MontoOperacionAutorizado = montoOperacionAutorizado,
            MontoDesembolsado = montoDesembolsado,
            SaldoPrincipalOperacionCrediticia = saldoPrincipal,
            SaldoProductosPorCobrar = saldoProductos,
            EAD = ead,
            TipoMonedaOperacion = tipoMonedaOperacion,
            FechaFormalizacion = fechaFormalizacion,
            FechaVencimiento = fechaVencimiento,
            DiasMaximaMorosidad = diasMaximaMorosidad,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    /// <summary>
    /// Reconstruye la entidad desde una fila devuelta por la función local
    /// <c>feguslocal.obtener_operaciones_credito_lista</c> (nombres de columna en snake_case / minúsculas).
    /// </summary>
    public static OperacionCredito FromListaRow(
        long idLoadLocal,
        string idOperacionCredito,
        int tipoPersonaDeudor,
        string idDeudor,
        int tipoOperacionSFN,
        int tipoOperacion,
        int tipoCatalogoSugef,
        int tipoCarteraCrediticia,
        int? codigoCategoriaRiesgo,
        decimal? tasaIncumplimiento,
        decimal? lgdPromedio,
        decimal? lgdRegulatorio,
        decimal montoOperacionAutorizado,
        decimal montoDesembolsado,
        decimal saldoPrincipalOperacionCrediticia,
        decimal saldoProductosPorCobrar,
        decimal ead,
        int tipoMonedaOperacion,
        DateTime fechaFormalizacion,
        DateTime fechaVencimiento,
        int diasMaximaMorosidad,
        decimal? montoCuotaPrincipalActual,
        decimal? montoCuotaInteresesActual,
        decimal? tasaInteresNominalVigente,
        string? indicadorTipoTasa,
        string indicadorBackToBack,
        string indicadorCreditoSindicado,
        string indicadorOperacionEspecial,
        string indicadorCambioClimatico,
        DateTime createdAtUtc,
        DateTime? updatedAtUtc)
    {
        return new OperacionCredito
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoPersonaDeudor = tipoPersonaDeudor,
            IdDeudor = idDeudor,
            TipoOperacionSFN = tipoOperacionSFN,
            TipoOperacion = tipoOperacion,
            TipoCatalogoSugef = tipoCatalogoSugef,
            TipoCarteraCrediticia = tipoCarteraCrediticia,
            CodigoCategoriaRiesgo = codigoCategoriaRiesgo,
            TasaIncumplimiento = tasaIncumplimiento,
            LGDPromedio = lgdPromedio,
            LGDRegulatorio = lgdRegulatorio,
            MontoOperacionAutorizado = montoOperacionAutorizado,
            MontoDesembolsado = montoDesembolsado,
            SaldoPrincipalOperacionCrediticia = saldoPrincipalOperacionCrediticia,
            SaldoProductosPorCobrar = saldoProductosPorCobrar,
            EAD = ead,
            TipoMonedaOperacion = tipoMonedaOperacion,
            FechaFormalizacion = fechaFormalizacion,
            FechaVencimiento = fechaVencimiento,
            DiasMaximaMorosidad = diasMaximaMorosidad,
            MontoCuotaPrincipalActual = montoCuotaPrincipalActual,
            MontoCuotaInteresesActual = montoCuotaInteresesActual,
            TasaInteresNominalVigente = tasaInteresNominalVigente,
            IndicadorTipoTasa = indicadorTipoTasa,
            IndicadorBackToBack = indicadorBackToBack,
            IndicadorCreditoSindicado = indicadorCreditoSindicado,
            IndicadorOperacionEspecial = indicadorOperacionEspecial,
            IndicadorCambioClimatico = indicadorCambioClimatico,
            CreatedAtUtc = createdAtUtc,
            UpdatedAtUtc = updatedAtUtc
        };
    }

    // ✏️ Métodos de dominio
    public void UpdateSaldo(decimal nuevoSaldoPrincipal)
    {
        SaldoPrincipalOperacionCrediticia = nuevoSaldoPrincipal;
        UpdatedAtUtc = DateTime.UtcNow;
    }

    public void UpdateMora(int nuevosDiasMora)
    {
        DiasMaximaMorosidad = nuevosDiasMora;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}