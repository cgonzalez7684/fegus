export interface DeudorDto {
  idCliente: number;
  tipoPersonaDeudor: number;
  idDeudor: string;
  tipoDeudorSFN: number;
  codigoSectorEconomico: number;
  tipoCapacidadPago: number;
  saldoTotalSegmentacion: number;
  tipoCondicionEspecialDeudor: number | null;
  fechaCalificacionRiesgo: string; // luego se puede convertir a Date
  tipoIndicadorGeneradorDivisas: number;
  tipoAsignacionCalificacion: number;
  categoriaCalificacion: number;
  calificacionRiesgo: string;
  codigoEmpresaCalificadora: number;
  indicadorVinculadoEntidad: number | null;
  indicadorVinculadoGrupoFinanciero: number | null;
  idGrupoInteresEconomico: number | null;
  tipoComportamientoPago: number;
  tipoActividadEconomicaDeudor: string;
  tipoComportamientoPagoSBD: number;
  tipoBeneficiarioSBD: number;
  totalOperacionesReestructuradasSBD: number;
  tipoIndicadorGeneradorDivisasSBD: number;
  riesgoCambiarioDeudor: number;
  montoIngresoTotalDeudor: number;
  totalCargaMensualCSD: number;
  indicadorCSD: number;
  saldoMoratoriaMayorUltMeses1421: number;
  numMesesMoratoriaMayor1421: number;
  saldoMoratoriaMayorUltMeses1516: number;
  numMesesMoratoriaMayor1516: number;
  numDiasAtraso1421: number;
  numDiasAtraso1516: number;
  fechaUltGestion: string;  
  codUsuarioUltGestion: string;
}
