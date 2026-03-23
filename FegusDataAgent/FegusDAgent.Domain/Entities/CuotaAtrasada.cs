namespace FegusDAgent.Domain.Entities;

public class CuotaAtrasada
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdOperacionCredito { get; private set; } = null!;
    public string TipoCuota { get; private set; } = null!;
    public int NumeroCuotaAtrasada { get; private set; }

    // 👤 Deudor
    public string TipoPersonaDeudor { get; private set; } = null!;
    public string IdDeudor { get; private set; } = null!;

    // ⏱️ Mora
    public int DiasAtraso { get; private set; }

    // 💰 Monto
    public decimal MontoCuotaAtrasada { get; private set; }

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private CuotaAtrasada() { }

    // 🏗️ Factory Method
    public static CuotaAtrasada Create(
        long idLoadLocal,
        string tipoPersonaDeudor,
        string idDeudor,
        string idOperacionCredito,
        string tipoCuota,
        int numeroCuotaAtrasada,
        int diasAtraso,
        decimal montoCuotaAtrasada)
    {
        return new CuotaAtrasada
        {
            IdLoadLocal = idLoadLocal,
            TipoPersonaDeudor = tipoPersonaDeudor,
            IdDeudor = idDeudor,
            IdOperacionCredito = idOperacionCredito,
            TipoCuota = tipoCuota,
            NumeroCuotaAtrasada = numeroCuotaAtrasada,
            DiasAtraso = diasAtraso,
            MontoCuotaAtrasada = montoCuotaAtrasada,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateMora(
        int nuevosDiasAtraso,
        decimal nuevoMontoCuota)
    {
        DiasAtraso = nuevosDiasAtraso;
        MontoCuotaAtrasada = nuevoMontoCuota;

        UpdatedAtUtc = DateTime.UtcNow;
    }
}