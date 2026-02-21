import { SUGEF_CATALOGS } from "../catalogs/sugef-catalogs";

export type GridColumnType =
  | 'text'
  | 'number'
  | 'date'
  | 'currency'
  | 'boolean';

export interface GridColumnConfig {
  field: string;
  header: string;
  type?: GridColumnType;
  width?: number;
  hide?: boolean;
  sortable?: boolean;
  filter?: boolean;
  catalog?: keyof typeof SUGEF_CATALOGS;
  editable?: boolean;
}
