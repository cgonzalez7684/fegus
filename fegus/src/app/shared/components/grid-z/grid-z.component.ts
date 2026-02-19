import { Component, Input, Output, EventEmitter,OnChanges, SimpleChanges } from '@angular/core';
import { AgGridAngular } from 'ag-grid-angular';
import { ColDef, GridReadyEvent, themeBalham, themeQuartz } from 'ag-grid-community';
import {
  ClientSideRowModelModule,  
  ColGroupDef,  
  GridOptions,  
  ModuleRegistry,
  RowSelectionModule,
  RowSelectionOptions,
  ValidationModule,
} from "ag-grid-community";
import { CommonModule } from '@angular/common';
import { GridApi } from 'ag-grid-community';
import { GridColumnConfig } from '../../models/grid-column-config.model';


@Component({
  selector: 'app-grid-z',
  standalone: true,
  imports: [CommonModule, AgGridAngular],
  templateUrl: './grid-z.component.html',
  styleUrls: ['./grid-z.component.scss']
})
export class GridZComponent implements OnChanges {

  private gridApi!: GridApi;
  public theme = themeQuartz;

  @Input() columnDefs: ColDef[] = [];
  @Input() rowData: any[] = [];
  @Input() pagination: boolean = true;
  @Input() pageSize: number = 10;
  @Input() height: string = '500px';
  @Input() gridConfig?: GridColumnConfig[];

  @Input() selectionMode: 'single' | 'multiple' = 'single';
  @Input() enableCheckboxSelection: boolean = false;

 /* @Input() rowSelection: RowSelectionOptions = {
    mode: 'singleRow',
    enableClickSelection: true
  };*/
  
  @Output() rowSelected = new EventEmitter<any>();
  @Output() selectionChanged = new EventEmitter<any[]>();

 defaultColDef: ColDef = {
    sortable: true,
    resizable: true,
    filter: true,
    minWidth: 120
  };

 // rowSelection!: RowSelectionOptions;

  ngOnChanges(changes: SimpleChanges) {

    if (changes['gridConfig'] && this.gridConfig?.length) {
      this.columnDefs = this.buildColumnDefsFromConfig(this.gridConfig);
    }

    if (changes['rowData'] && this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
      setTimeout(() => {
        this.gridApi.autoSizeAllColumns();
      }, 0);
    }

    this.configureRowSelection();

  }

  private configureRowSelection(): void {

    this.rowSelection = {
      mode: this.selectionMode === 'multiple'
        ? 'multiRow'
        : 'singleRow',
      enableClickSelection: true
    };

    if (this.enableCheckboxSelection && this.selectionMode === 'multiple') {
      this.defaultColDef = {
        ...this.defaultColDef,
        headerCheckboxSelection: true,
        checkboxSelection: false
      };
    }
  }

  onGridReady(event: GridReadyEvent) {
    this.gridApi = event.api;
    setTimeout(() => {
      this.gridApi.autoSizeAllColumns();
      // Si el grid queda con espacio sobrante
      this.gridApi.sizeColumnsToFit();
    }, 0);
    //console.log('ColumnDefs:', this.columnDefs);
    //console.log('RowData:', this.rowData);
  }

  onRowSelectedEvent(event: any):void {
    if (event.node.selected) {
      this.rowSelected.emit(event);
    }
  }

  onSelectionChangedEvent(): void {

    if (this.selectionMode === 'multiple' && this.gridApi) {
      const selectedRows = this.gridApi.getSelectedRows();
      this.selectionChanged.emit(selectedRows);
    }
  }

  private buildColumnDefsFromConfig(config: GridColumnConfig[]): ColDef[] {

    return config.map(c => ({

      field: c.field,
      headerName: c.header,
      width: c.width,
      hide: c.hide ?? false,
      sortable: c.sortable ?? true,
      filter: this.resolveFilterType(c.type),
      valueFormatter: this.resolveFormatter(c.type)

    }));
  }

private resolveFilterType(type?: string): string | boolean {

  switch (type) {
    case 'number':
    case 'currency':
      return 'agNumberColumnFilter';

    case 'date':
      return 'agDateColumnFilter';

    case 'boolean':
      return 'agSetColumnFilter';

    default:
      return 'agTextColumnFilter';
  }
}

private resolveFormatter(type?: string) {

  switch (type) {

    case 'currency':
      return (params: any) =>
        params.value == null
          ? ''
          : new Intl.NumberFormat('es-CR', {
              minimumFractionDigits: 2,
              maximumFractionDigits: 2
            }).format(params.value);

    case 'date':
      return (params: any) =>
        params.value
          ? new Date(params.value).toLocaleDateString('es-CR')
          : '';

    default:
      return undefined;
  }
}



}
