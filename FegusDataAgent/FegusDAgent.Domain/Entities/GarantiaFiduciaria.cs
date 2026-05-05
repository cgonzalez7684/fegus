namespace FegusDAgent.Domain.Entities;

public class GarantiaFiduciaria
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdGarantiaFiduciaria { get; private set; } = null!;

    // 👤 Fiador
    public string TipoPersona { get; private set; } = null!;
    public string IdFiador { get; private set; } = null!;

    // 💰 Montos
    public decimal? SalarioNetoFiador { get; private set; }
    public decimal? MontoAvalado { get; private set; }
    public decimal? PorcentajeMitigacionFondo { get; private set; }
    public decimal? PorcentajeEstimacionMinimoFondo { get; private set; }

    // 📅 Fechas
    public DateTime? FechaVerificacionAsalariado { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private GarantiaFiduciaria() { }

    // 🏗️ Factory Method
    public static GarantiaFiduciaria Create(
        long idLoadLocal,
        string idGarantiaFiduciaria,
        string tipoPersona,
        string idFiador,
        decimal? salarioNetoFiador,
        DateTime? fechaVerificacionAsalariado,
        decimal? montoAvalado,
        decimal? porcentajeMitigacionFondo,
        decimal? porcentajeEstimacionMinimoFondo)
    {
        return new GarantiaFiduciaria
        {
            IdLoadLocal = idLoadLocal,
            IdGarantiaFiduciaria = idGarantiaFiduciaria,
            TipoPersona = tipoPersona,
            IdFiador = idFiador,
            SalarioNetoFiador = salarioNetoFiador,
            FechaVerificacionAsalariado = fechaVerificacionAsalariado,
            MontoAvalado = montoAvalado,
            PorcentajeMitigacionFondo = porcentajeMitigacionFondo,
            PorcentajeEstimacionMinimoFondo = porcentajeEstimacionMinimoFondo,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateMontos(
        decimal? nuevoSalarioNeto,
        decimal? nuevoMontoAvalado,
        decimal? nuevoPorcentajeMitigacion,
        decimal? nuevoPorcentajeEstimacion)
    {
        SalarioNetoFiador = nuevoSalarioNeto;
        MontoAvalado = nuevoMontoAvalado;
        PorcentajeMitigacionFondo = nuevoPorcentajeMitigacion;
        PorcentajeEstimacionMinimoFondo = nuevoPorcentajeEstimacion;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}
