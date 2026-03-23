namespace FegusDAgent.Domain.Entities;

public class GarantiaMobiliaria
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdGarantiaMobiliaria { get; private set; } = null!;

    // 📅 Fechas clave
    public DateTime FechaPublicidadGM { get; private set; }
    public DateTime FechaVencimientoGM { get; private set; }
    public DateTime FechaMontoReferencia { get; private set; }

    // 💰 Montos
    public decimal MontoGarantiaMobiliaria { get; private set; }
    public decimal MontoReferencia { get; private set; }
    public string TipoMonedaMontoReferencia { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private GarantiaMobiliaria() { }

    // 🏗️ Factory Method
    public static GarantiaMobiliaria Create(
        long idLoadLocal,
        string idGarantiaMobiliaria,
        DateTime fechaPublicidadGM,
        decimal montoGarantiaMobiliaria,
        DateTime fechaVencimientoGM,
        DateTime fechaMontoReferencia,
        decimal montoReferencia,
        string tipoMonedaMontoReferencia)
    {
        return new GarantiaMobiliaria
        {
            IdLoadLocal = idLoadLocal,
            IdGarantiaMobiliaria = idGarantiaMobiliaria,
            FechaPublicidadGM = fechaPublicidadGM,
            MontoGarantiaMobiliaria = montoGarantiaMobiliaria,
            FechaVencimientoGM = fechaVencimientoGM,
            FechaMontoReferencia = fechaMontoReferencia,
            MontoReferencia = montoReferencia,
            TipoMonedaMontoReferencia = tipoMonedaMontoReferencia,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateMontos(
        decimal nuevoMontoGarantia,
        decimal nuevoMontoReferencia)
    {
        MontoGarantiaMobiliaria = nuevoMontoGarantia;
        MontoReferencia = nuevoMontoReferencia;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}