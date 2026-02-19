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
}
