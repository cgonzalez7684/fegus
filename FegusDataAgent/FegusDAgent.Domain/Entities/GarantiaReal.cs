namespace FegusDAgent.Domain.Entities;

public class GarantiaReal
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdGarantiaReal { get; private set; } = null!;

    // 📋 Clasificación
    public string TipoBienGarantiaReal { get; private set; } = null!;
    public string TipoMonedaTasacion { get; private set; } = null!;
    public string IndicadorPolizaGarantiaReal { get; private set; } = null!;
    public string TipoColateralReal { get; private set; } = null!;

    // 💰 Tasación
    public decimal MontoUltimaTasacionTerreno { get; private set; }
    public decimal MontoUltimaTasacionNoTerreno { get; private set; }
    public decimal PorcentajeRecuperacionColateralReal { get; private set; }
    public decimal Tiempo { get; private set; }
    public decimal PorcentajeFactorDescuentoTiempo { get; private set; }

    // 📅 Fechas
    public DateTime FechaUltimaTasacionGarantia { get; private set; }
    public DateTime FechaUltimoSeguimientoGarantia { get; private set; }
    public DateTime? FechaConstruccion { get; private set; }

    // 👤 Tasador
    public string TipoPersonaTasador { get; private set; } = null!;
    public string IdTasador { get; private set; } = null!;
    public string? TipoPersonaEmpresaTasadora { get; private set; }
    public string? IdEmpresaTasadora { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private GarantiaReal() { }

    // 🏗️ Factory Method
    public static GarantiaReal Create(
        long idLoadLocal,
        string idGarantiaReal,
        string tipoBienGarantiaReal,
        decimal montoUltimaTasacionTerreno,
        decimal montoUltimaTasacionNoTerreno,
        DateTime fechaUltimaTasacionGarantia,
        DateTime fechaUltimoSeguimientoGarantia,
        string tipoMonedaTasacion,
        DateTime? fechaConstruccion,
        string tipoPersonaTasador,
        string idTasador,
        string? tipoPersonaEmpresaTasadora,
        string? idEmpresaTasadora,
        string indicadorPolizaGarantiaReal,
        string tipoColateralReal,
        decimal porcentajeRecuperacionColateralReal,
        decimal tiempo,
        decimal porcentajeFactorDescuentoTiempo)
    {
        return new GarantiaReal
        {
            IdLoadLocal = idLoadLocal,
            IdGarantiaReal = idGarantiaReal,
            TipoBienGarantiaReal = tipoBienGarantiaReal,
            MontoUltimaTasacionTerreno = montoUltimaTasacionTerreno,
            MontoUltimaTasacionNoTerreno = montoUltimaTasacionNoTerreno,
            FechaUltimaTasacionGarantia = fechaUltimaTasacionGarantia,
            FechaUltimoSeguimientoGarantia = fechaUltimoSeguimientoGarantia,
            TipoMonedaTasacion = tipoMonedaTasacion,
            FechaConstruccion = fechaConstruccion,
            TipoPersonaTasador = tipoPersonaTasador,
            IdTasador = idTasador,
            TipoPersonaEmpresaTasadora = tipoPersonaEmpresaTasadora,
            IdEmpresaTasadora = idEmpresaTasadora,
            IndicadorPolizaGarantiaReal = indicadorPolizaGarantiaReal,
            TipoColateralReal = tipoColateralReal,
            PorcentajeRecuperacionColateralReal = porcentajeRecuperacionColateralReal,
            Tiempo = tiempo,
            PorcentajeFactorDescuentoTiempo = porcentajeFactorDescuentoTiempo,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateTasacion(
        decimal nuevoMontoTasacionTerreno,
        decimal nuevoMontoTasacionNoTerreno,
        DateTime nuevaFechaTasacion)
    {
        MontoUltimaTasacionTerreno = nuevoMontoTasacionTerreno;
        MontoUltimaTasacionNoTerreno = nuevoMontoTasacionNoTerreno;
        FechaUltimaTasacionGarantia = nuevaFechaTasacion;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}
