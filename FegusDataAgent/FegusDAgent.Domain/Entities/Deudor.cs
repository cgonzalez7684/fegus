using System;

namespace FegusDAgent.Domain.Entities;

public class Deudor
{
    // --- Clave primaria compuesta ---
    public int IdCliente { get; set; }
    public decimal TipoPersonaDeudor { get; set; }
    public string IdDeudor { get; set; } = default!;

    // --- Datos generales ---
    public int? TipoDeudorSFN { get; set; }
    public decimal? CodigoSectorEconomico { get; set; }
    public int? TipoCapacidadPago { get; set; }
    public decimal? SaldoTotalSegmentacion { get; set; }
    public int? TipoCondicionEspecialDeudor { get; set; }

    // --- Calificación de riesgo ---
    public string? FechaCalificacionRiesgo { get; set; }
    public int? TipoIndicadorGeneradorDivisas { get; set; }
    public int? TipoAsignacionCalificacion { get; set; }
    public decimal? CategoriaCalificacion { get; set; }
    public string? CalificacionRiesgo { get; set; }
    public decimal? CodigoEmpresaCalificadora { get; set; }

    // --- Vinculaciones ---
    public string? IndicadorVinculadoEntidad { get; set; }
    public string? IndicadorVinculadoGrupoFinanciero { get; set; }
    public decimal? IdGrupoInteresEconomico { get; set; }

    // --- Comportamiento de pago ---
    public int? TipoComportamientoPago { get; set; }
    public string? TipoActividadEconomicaDeudor { get; set; }
    public int? TipoComportamientoPagoSBD { get; set; }
    public int? TipoBeneficiarioSBD { get; set; }
    public int? TotalOperacionesReestructuradasSBD { get; set; }
    public int? TipoIndicadorGeneradorDivisasSBD { get; set; }
    public int? RiesgoCambiarioDeudor { get; set; }

    // --- Información financiera ---
    public decimal? MontoIngresoTotalDeudor { get; set; }
    public decimal? TotalCargaMensualCSD { get; set; }
    public decimal? IndicadorCSD { get; set; }

    // --- Moratoria ---
    public decimal? SaldoMoratoriaMayorUltMeses1421 { get; set; }
    public int? NumMesesMoratoriaMayor1421 { get; set; }
    public decimal? SaldoMoratoriaMayorUltMeses1516 { get; set; }
    public int? NumMesesMoratoriaMayor1516 { get; set; }
    public int? NumDiasAtraso1421 { get; set; }
    public int? NumDiasAtraso1516 { get; set; }

    // --- Auditoría ---
    public DateTime FechaUltGestion { get; set; }
    public string? CodUsuarioUltGestion { get; set; }
}
