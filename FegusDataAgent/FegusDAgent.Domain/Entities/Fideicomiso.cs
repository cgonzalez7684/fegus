namespace FegusDAgent.Domain.Entities;

public class Fideicomiso
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdFideicomisoGarantia { get; private set; } = null!;

    // 📅 Fechas
    public DateTime FechaConstitucion { get; private set; }
    public DateTime FechaVencimiento { get; private set; }

    // 💰 Valor nominal
    public decimal ValorNominalFideicomiso { get; private set; }
    public string TipoMonedaValorNominalFideicomiso { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private Fideicomiso() { }

    // 🏗️ Factory Method
    public static Fideicomiso Create(
        long idLoadLocal,
        string idFideicomisoGarantia,
        DateTime fechaConstitucion,
        DateTime fechaVencimiento,
        decimal valorNominalFideicomiso,
        string tipoMonedaValorNominalFideicomiso)
    {
        return new Fideicomiso
        {
            IdLoadLocal = idLoadLocal,
            IdFideicomisoGarantia = idFideicomisoGarantia,
            FechaConstitucion = fechaConstitucion,
            FechaVencimiento = fechaVencimiento,
            ValorNominalFideicomiso = valorNominalFideicomiso,
            TipoMonedaValorNominalFideicomiso = tipoMonedaValorNominalFideicomiso,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateValorNominal(decimal nuevoValorNominal)
    {
        ValorNominalFideicomiso = nuevoValorNominal;
        UpdatedAtUtc = DateTime.UtcNow;
    }
}