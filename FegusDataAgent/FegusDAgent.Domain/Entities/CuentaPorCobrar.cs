namespace FegusDAgent.Domain.Entities;

public class CuentaPorCobrar
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string IdCuentaCobrarAsociada { get; private set; } = null!;

    // 📚 Información contable
    public string CuentaContableCuentaCobrarAsociada { get; private set; } = null!;
    public string TipoCatalogoSugef { get; private set; } = null!;

    // 💰 Información financiera
    public decimal SaldoCuentaCobrarAsociada { get; private set; }
    public string TipoMonedaCuentaCobrarAsociada { get; private set; } = null!;

    // ⏱️ Mora
    public int DiasAtrasoCuentaCobrarAsociada { get; private set; }

    // 📅 Fechas
    public DateTime FechaRegistroCuentaCobrarAsociada { get; private set; }
    public DateTime FechaVencimientoCuentaCobrarAsociada { get; private set; }

    // 📝 Concepto (opcional)
    public string? Concepto { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private CuentaPorCobrar() { }

    // 🏗️ Factory Method
    public static CuentaPorCobrar Create(
        long idLoadLocal,
        string idOperacionCredito,
        string idCuentaCobrarAsociada,
        string cuentaContableCuentaCobrarAsociada,
        string tipoCatalogoSugef,
        decimal saldoCuentaCobrarAsociada,
        string tipoMonedaCuentaCobrarAsociada,
        int diasAtrasoCuentaCobrarAsociada,
        DateTime fechaRegistroCuentaCobrarAsociada,
        DateTime fechaVencimientoCuentaCobrarAsociada,
        string? concepto)
    {
        return new CuentaPorCobrar
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            IdCuentaCobrarAsociada = idCuentaCobrarAsociada,
            CuentaContableCuentaCobrarAsociada = cuentaContableCuentaCobrarAsociada,
            TipoCatalogoSugef = tipoCatalogoSugef,
            SaldoCuentaCobrarAsociada = saldoCuentaCobrarAsociada,
            TipoMonedaCuentaCobrarAsociada = tipoMonedaCuentaCobrarAsociada,
            DiasAtrasoCuentaCobrarAsociada = diasAtrasoCuentaCobrarAsociada,
            FechaRegistroCuentaCobrarAsociada = fechaRegistroCuentaCobrarAsociada,
            FechaVencimientoCuentaCobrarAsociada = fechaVencimientoCuentaCobrarAsociada,
            Concepto = concepto,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateSaldoYMora(
        decimal nuevoSaldo,
        int nuevosDiasAtraso)
    {
        SaldoCuentaCobrarAsociada = nuevoSaldo;
        DiasAtrasoCuentaCobrarAsociada = nuevosDiasAtraso;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}