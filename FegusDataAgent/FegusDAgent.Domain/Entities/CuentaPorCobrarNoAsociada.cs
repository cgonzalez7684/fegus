namespace FegusDAgent.Domain.Entities;

public class CuentaPorCobrarNoAsociada
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;

    // 👤 Información del deudor
    public string TipoPersonaDeudor { get; private set; } = null!;
    public string IdPersona { get; private set; } = null!;

    // 💰 Información monetaria
    public string TipoMonedaMonto { get; private set; } = null!;
    public decimal MontoOriginal { get; private set; }

    // 📚 Catálogo SUGEF
    public string TipoCatalogoSugef { get; private set; } = null!;

    // 💰 Saldos contables
    public string CuentaContableSaldoPrincipal { get; private set; } = null!;
    public decimal SaldoPrincipal { get; private set; }

    public string CuentaContableSaldoProductosPorCobrar { get; private set; } = null!;
    public decimal SaldoProductosPorCobrar { get; private set; }

    // 📅 Fechas
    public DateTime FechaRegistroContable { get; private set; }
    public DateTime FechaExigibilidad { get; private set; }
    public DateTime FechaVencimiento { get; private set; }

    // 💰 Estimación
    public decimal MontoEstimacionRegistrada { get; private set; }

    // 🏢 Dependencia
    public string TipoDependencia { get; private set; } = null!;

    // ⏱️ Mora
    public int DiasMora { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private CuentaPorCobrarNoAsociada() { }

    // 🏗️ Factory Method
    public static CuentaPorCobrarNoAsociada Create(
        long idLoadLocal,
        string idOperacionCredito,
        string tipoPersonaDeudor,
        string idPersona,
        string tipoMonedaMonto,
        decimal montoOriginal,
        string tipoCatalogoSugef,
        string cuentaContableSaldoPrincipal,
        decimal saldoPrincipal,
        string cuentaContableSaldoProductosPorCobrar,
        decimal saldoProductosPorCobrar,
        DateTime fechaRegistroContable,
        DateTime fechaExigibilidad,
        DateTime fechaVencimiento,
        decimal montoEstimacionRegistrada,
        string tipoDependencia,
        int diasMora)
    {
        return new CuentaPorCobrarNoAsociada
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoPersonaDeudor = tipoPersonaDeudor,
            IdPersona = idPersona,
            TipoMonedaMonto = tipoMonedaMonto,
            MontoOriginal = montoOriginal,
            TipoCatalogoSugef = tipoCatalogoSugef,
            CuentaContableSaldoPrincipal = cuentaContableSaldoPrincipal,
            SaldoPrincipal = saldoPrincipal,
            CuentaContableSaldoProductosPorCobrar = cuentaContableSaldoProductosPorCobrar,
            SaldoProductosPorCobrar = saldoProductosPorCobrar,
            FechaRegistroContable = fechaRegistroContable,
            FechaExigibilidad = fechaExigibilidad,
            FechaVencimiento = fechaVencimiento,
            MontoEstimacionRegistrada = montoEstimacionRegistrada,
            TipoDependencia = tipoDependencia,
            DiasMora = diasMora,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Métodos de actualización controlada
    public void UpdateSaldos(
        decimal nuevoSaldoPrincipal,
        decimal nuevoSaldoProductos,
        decimal nuevoMontoEstimacion)
    {
        SaldoPrincipal = nuevoSaldoPrincipal;
        SaldoProductosPorCobrar = nuevoSaldoProductos;
        MontoEstimacionRegistrada = nuevoMontoEstimacion;

        UpdatedAtUtc = DateTime.UtcNow;
    }

    public void UpdateMora(int nuevosDiasMora)
    {
        DiasMora = nuevosDiasMora;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}