
import { GridColumnConfig } from '../../../../shared/models/grid-column-config.model';

export const DEUDOR_GRID_CONFIG: GridColumnConfig[] = [

  // =========================
  // IDENTIFICACIÓN
  // =========================

  { field: 'idCliente', header: 'Cliente', type: 'number', width: 120 },
  { field: 'idDeudor', header: 'Identificación', type: 'text', width: 160 },
  { field: 'tipoPersonaDeudor', header: 'Tipo Persona', type: 'number' },
  { field: 'tipoDeudorSFN', header: 'Tipo Deudor SFN', type: 'number' },

  // =========================
  // INFORMACIÓN ECONÓMICA
  // =========================

  { field: 'codigoSectorEconomico', header: 'Sector Económico', type: 'number' },
  { field: 'tipoActividadEconomicaDeudor', header: 'Actividad Económica', type: 'text' },
  { field: 'tipoCapacidadPago', header: 'Capacidad Pago', type: 'number' },
  { field: 'saldoTotalSegmentacion', header: 'Saldo Segmentación', type: 'currency' },
  { field: 'montoIngresoTotalDeudor', header: 'Ingreso Total', type: 'currency' },
  { field: 'totalCargaMensualCSD', header: 'Carga Mensual CSD', type: 'currency' },
  { field: 'indicadorCSD', header: 'Indicador CSD', type: 'number' },

  // =========================
  // CONDICIONES ESPECIALES
  // =========================

  { field: 'tipoCondicionEspecialDeudor', header: 'Condición Especial', type: 'number' },
  { field: 'indicadorVinculadoEntidad', header: 'Vinculado Entidad', type: 'number' },
  { field: 'indicadorVinculadoGrupoFinanciero', header: 'Vinculado Grupo Financiero', type: 'number' },
  { field: 'idGrupoInteresEconomico', header: 'Grupo Interés Económico', type: 'number' },

  // =========================
  // CALIFICACIÓN DE RIESGO
  // =========================

  { field: 'fechaCalificacionRiesgo', header: 'Fecha Calificación', type: 'date' },
  { field: 'tipoIndicadorGeneradorDivisas', header: 'Indicador Divisas', type: 'number' },
  { field: 'tipoAsignacionCalificacion', header: 'Asignación Calificación', type: 'number' },
  { field: 'categoriaCalificacion', header: 'Categoría Calificación', type: 'number' },
  { field: 'calificacionRiesgo', header: 'Calificación Riesgo', type: 'text' },
  { field: 'codigoEmpresaCalificadora', header: 'Empresa Calificadora', type: 'number' },

  // =========================
  // SBD
  // =========================

  { field: 'tipoComportamientoPago', header: 'Comportamiento Pago', type: 'number' },
  { field: 'tipoComportamientoPagoSBD', header: 'Comportamiento Pago SBD', type: 'number' },
  { field: 'tipoBeneficiarioSBD', header: 'Beneficiario SBD', type: 'number' },
  { field: 'totalOperacionesReestructuradasSBD', header: 'Operaciones Reestructuradas SBD', type: 'number' },
  { field: 'tipoIndicadorGeneradorDivisasSBD', header: 'Indicador Divisas SBD', type: 'number' },
  { field: 'riesgoCambiarioDeudor', header: 'Riesgo Cambiario', type: 'number' },

  // =========================
  // MORATORIA 14-21
  // =========================

  { field: 'saldoMoratoriaMayorUltMeses1421', header: 'Saldo Moratoria 14-21', type: 'currency' },
  { field: 'numMesesMoratoriaMayor1421', header: 'Meses Moratoria 14-21', type: 'number' },
  { field: 'numDiasAtraso1421', header: 'Días Atraso 14-21', type: 'number' },

  // =========================
  // MORATORIA 15-16
  // =========================

  { field: 'saldoMoratoriaMayorUltMeses1516', header: 'Saldo Moratoria 15-16', type: 'currency' },
  { field: 'numMesesMoratoriaMayor1516', header: 'Meses Moratoria 15-16', type: 'number' },
  { field: 'numDiasAtraso1516', header: 'Días Atraso 15-16', type: 'number' },

  // =========================
  // CONTROL INTERNO
  // =========================

  { field: 'fechaUltGestion', header: 'Fecha Última Gestión', type: 'date' },
  { field: 'codUsuarioUltGestion', header: 'Usuario Última Gestión', type: 'text' }

];

