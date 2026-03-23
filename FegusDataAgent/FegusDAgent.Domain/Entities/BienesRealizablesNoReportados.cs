namespace FegusDAgent.Domain.Entities;

public class BienesRealizablesNoReportados
{
    // 🔑 Primary Key (compuesta)
    public long IdLoadLocal { get; private set; }
    public string IdBienRealizable { get; private set; } = null!;

    // 📊 Información del bien
    public string IndicadorGarantia { get; private set; } = null!;
    public string IdGarantia { get; private set; } = null!;
    public string IdBien { get; private set; } = null!;
    public string TipoBien { get; private set; } = null!;

    // 📌 Motivo de no reporte
    public string TipoMotivoBienRealizableNoReportado { get; private set; } = null!;

    // 💰 Valores financieros
    public decimal UltimoValorContable { get; private set; }
    public decimal ValorRecuperadoNeto { get; private set; }

    // 🔗 Relación con operación de crédito
    public string IdOperacionCreditoFinanciamiento { get; private set; } = null!;

    // 🕒 Auditoría
    public DateTime CreatedAtUtc { get; private set; }
    public DateTime? UpdatedAtUtc { get; private set; }

    // 🔒 Constructor privado
    private BienesRealizablesNoReportados() { }

    // 🏗️ Factory Method
    public static BienesRealizablesNoReportados Create(
        long idLoadLocal,
        string idBienRealizable,
        string indicadorGarantia,
        string idGarantia,
        string idBien,
        string tipoBien,
        string tipoMotivoBienRealizableNoReportado,
        decimal ultimoValorContable,
        decimal valorRecuperadoNeto,
        string idOperacionCreditoFinanciamiento)
    {
        return new BienesRealizablesNoReportados
        {
            IdLoadLocal = idLoadLocal,
            IdBienRealizable = idBienRealizable,
            IndicadorGarantia = indicadorGarantia,
            IdGarantia = idGarantia,
            IdBien = idBien,
            TipoBien = tipoBien,
            TipoMotivoBienRealizableNoReportado = tipoMotivoBienRealizableNoReportado,
            UltimoValorContable = ultimoValorContable,
            ValorRecuperadoNeto = valorRecuperadoNeto,
            IdOperacionCreditoFinanciamiento = idOperacionCreditoFinanciamiento,
            CreatedAtUtc = DateTime.UtcNow
        };
    }

    // ✏️ Método de actualización controlada
    public void UpdateValores(
        decimal nuevoUltimoValorContable,
        decimal nuevoValorRecuperadoNeto)
    {
        UltimoValorContable = nuevoUltimoValorContable;
        ValorRecuperadoNeto = nuevoValorRecuperadoNeto;

        UpdatedAtUtc = DateTime.UtcNow;
    }
}