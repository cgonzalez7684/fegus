namespace FegusDAgent.Domain.Entities;

public class OperacionComprada
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string TipoPersonaEntidadOperacion { get; private set; } = null!;
    public string IdentidadOperacionComprada { get; private set; } = null!;
    public string TipoPersonaDeudor { get; private set; } = null!;
    public string IdDeudorComprada { get; private set; } = null!;
    public string IdOperacionCreditoComprada { get; private set; } = null!;

    // 📅 Fecha de desembolso original
    public DateTime FechaDesembolsoDeudor { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private OperacionComprada() { }

    // 🏗️ Factory Method
    public static OperacionComprada Create(
        long idLoadLocal,
        string idOperacionCredito,
        string tipoPersonaEntidadOperacion,
        string identidadOperacionComprada,
        string tipoPersonaDeudor,
        string idDeudorComprada,
        string idOperacionCreditoComprada,
        DateTime fechaDesembolsoDeudor)
    {
        return new OperacionComprada
        {
            IdLoadLocal = idLoadLocal,
            IdOperacionCredito = idOperacionCredito,
            TipoPersonaEntidadOperacion = tipoPersonaEntidadOperacion,
            IdentidadOperacionComprada = identidadOperacionComprada,
            TipoPersonaDeudor = tipoPersonaDeudor,
            IdDeudorComprada = idDeudorComprada,
            IdOperacionCreditoComprada = idOperacionCreditoComprada,
            FechaDesembolsoDeudor = fechaDesembolsoDeudor,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateFechaDesembolso(DateTime nuevaFechaDesembolso)
    {
        FechaDesembolsoDeudor = nuevaFechaDesembolso;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}