namespace FegusDAgent.Domain.Entities;

public class BienesRealizables
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdBienRealizable { get; private set; } = null!;

    // 📊 Información general
    public string TipoAdquisicionBien { get; private set; } = null!;
    public string IndicadorGarantia { get; private set; } = null!;
    public string IdGarantia { get; private set; } = null!;
    public string IdBien { get; private set; } = null!;
    public string TipoBien { get; private set; } = null!;

    // 📅 Fechas
    public DateTime FechaAdjudicacionDacionBien { get; private set; }
    public DateTime FechaUltimaTasacionBien { get; private set; }

    // 💰 Valores contables
    public decimal SaldoRegistroContable { get; private set; }
    public string TipoMonedaSaldoRegistroContable { get; private set; } = null!;

    public decimal MontoUltimaTasacion { get; private set; }
    public string TipoMonedaMontoAvaluo { get; private set; } = null!;

    public decimal SaldoContableCreditoCancelado { get; private set; }
    public string TipoMonedaSaldoContableCreditoCancelado { get; private set; } = null!;

    public decimal MontoEstimacion { get; private set; }

    // 📚 Catálogos SUGEF
    public string CuentaCatalogoSugef { get; private set; } = null!;
    public string TipoCatalogoSugef { get; private set; } = null!;

    // 👤 Tasadores
    public string TipoPersonaTasador { get; private set; } = null!;
    public string IdTasador { get; private set; } = null!;
    public string TipoPersonaEmpresaTasadora { get; private set; } = null!;
    public string IdEmpresaTasadora { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private BienesRealizables() { }

    // 🏗️ Factory Method
    public static BienesRealizables Create(
        long idLoadLocal,
        string tipoAdquisicionBien,
        string idBienRealizable,
        string indicadorGarantia,
        string idGarantia,
        string idBien,
        string tipoBien,
        DateTime fechaAdjudicacionDacionBien,
        decimal saldoRegistroContable,
        string tipoMonedaSaldoRegistroContable,
        string cuentaCatalogoSugef,
        string tipoCatalogoSugef,
        DateTime fechaUltimaTasacionBien,
        decimal montoUltimaTasacion,
        string tipoMonedaMontoAvaluo,
        string tipoPersonaTasador,
        string idTasador,
        string tipoPersonaEmpresaTasadora,
        string idEmpresaTasadora,
        decimal saldoContableCreditoCancelado,
        string tipoMonedaSaldoContableCreditoCancelado,
        decimal montoEstimacion)
    {
        return new BienesRealizables
        {
            IdLoadLocal = idLoadLocal,
            TipoAdquisicionBien = tipoAdquisicionBien,
            IdBienRealizable = idBienRealizable,
            IndicadorGarantia = indicadorGarantia,
            IdGarantia = idGarantia,
            IdBien = idBien,
            TipoBien = tipoBien,
            FechaAdjudicacionDacionBien = fechaAdjudicacionDacionBien,
            SaldoRegistroContable = saldoRegistroContable,
            TipoMonedaSaldoRegistroContable = tipoMonedaSaldoRegistroContable,
            CuentaCatalogoSugef = cuentaCatalogoSugef,
            TipoCatalogoSugef = tipoCatalogoSugef,
            FechaUltimaTasacionBien = fechaUltimaTasacionBien,
            MontoUltimaTasacion = montoUltimaTasacion,
            TipoMonedaMontoAvaluo = tipoMonedaMontoAvaluo,
            TipoPersonaTasador = tipoPersonaTasador,
            IdTasador = idTasador,
            TipoPersonaEmpresaTasadora = tipoPersonaEmpresaTasadora,
            IdEmpresaTasadora = idEmpresaTasadora,
            SaldoContableCreditoCancelado = saldoContableCreditoCancelado,
            TipoMonedaSaldoContableCreditoCancelado = tipoMonedaSaldoContableCreditoCancelado,
            MontoEstimacion = montoEstimacion,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateValores(
        decimal nuevoSaldoRegistroContable,
        decimal nuevoMontoUltimaTasacion,
        decimal nuevoMontoEstimacion)
    {
        SaldoRegistroContable = nuevoSaldoRegistroContable;
        MontoUltimaTasacion = nuevoMontoUltimaTasacion;
        MontoEstimacion = nuevoMontoEstimacion;

        UpdatedAtUtc = DateTime.UtcNow;
    }
}