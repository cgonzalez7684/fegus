namespace FegusDAgent.Domain.Entities;

public class Modificacion
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string TipoModificacion { get; private set; } = null!;

    // 📅 Fecha de modificación
    public DateTime FechaModificacion { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private Modificacion() { }

    // 🏗️ Factory Method
    public static Modificacion Create(
        long idLoadLocal,
        string idOperacionCredito,
        DateTime fechaModificacion,
        string tipoModificacion)
    {
        return new Modificacion
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            FechaModificacion = fechaModificacion,
            TipoModificacion = tipoModificacion,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateFecha(DateTime nuevaFechaModificacion)
    {
        FechaModificacion = nuevaFechaModificacion;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}