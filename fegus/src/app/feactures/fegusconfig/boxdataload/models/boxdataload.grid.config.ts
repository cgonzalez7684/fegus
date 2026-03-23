import { GridColumnConfig } from "../../../../shared/models/grid-column-config.model";

export const BOXDATALOAD_GRID_CONFIG: GridColumnConfig[] = [

  // =========================
  // ESTRUCTURA DE LA TABLA
  // =========================  
  { field: 'idCliente', header: 'ID Cliente', type: 'number', width: 100 },
  { field: 'idLoad', header: 'ID Carga', type: 'number', width: 100 },
  { field: 'stateCode', header: 'Estado', type: 'text', width: 150 },
  { field: 'isActive', header: 'Activo', type: 'text', width: 100 },
  { field: 'asofDate', header: 'Corte', type: 'text', width: 150 },
  { field: 'createdAtUtc', header: 'Creado', type: 'text', width: 150 },
  { field: 'updatedAtUtc', header: 'Actualizado', type: 'text', width: 150 }

]