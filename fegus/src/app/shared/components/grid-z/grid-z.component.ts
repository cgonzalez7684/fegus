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
  templateUrl: './grid-z.component.html'
})
export class GridZComponent implements OnChanges {

  // ==============================
  // INPUTS (Metadata Driven)
  // ==============================

  @Input() columns: GridColumnConfig[] = [];
  @Input() rowData: any[] = [];

  @Input() selectionMode: 'single' | 'multiple' = 'single';
  @Input() enableCheckboxSelection: boolean = false;

  @Input() pagination: boolean = true;
  @Input() pageSize: number = 10;
  @Input() height: string = '500px';

  // ==============================
  // OUTPUTS
  // ==============================

  @Output() rowSelected = new EventEmitter<any>();
  @Output() selectionChanged = new EventEmitter<any[]>();

  // ==============================
  // GRID INTERNAL
  // ==============================

  internalColumnDefs: ColDef[] = [];
  rowSelection: any;
  gridApi: any;

  defaultColDef: ColDef = {
    sortable: true,
    filter: true,
    resizable: true,
    minWidth: 120
  };

  // ==============================
  // LIFECYCLE
  // ==============================

  ngOnChanges(changes: SimpleChanges): void {
    this.buildColumns();
    this.configureSelection();
  }

  // ==============================
  // BUILD COLUMNS FROM METADATA
  // ==============================

  private buildColumns(): void {

    this.internalColumnDefs = this.columns.map(col => {

      const base: ColDef = {
        field: col.field,
        headerName: col.header,
        hide: col.hide ?? false,
        width: col.width,
        sortable: true,
        filter: true,
        resizable: true,
        checkboxSelection: false,
        headerCheckboxSelection: false
      };

      if (col.type === 'number') {
        base.filter = 'agNumberColumnFilter';
      }

      if (col.type === 'date') {
        base.filter = 'agDateColumnFilter';
      }

      return base;
    });

  }

  // ==============================
  // SELECTION CONFIG
  // ==============================

  private configureSelection(): void {

    const isMultiple = this.selectionMode === 'multiple';

    // Construir columnas SIEMPRE limpias (sin checkbox por columna)
    this.buildColumns();

    // Control total desde RowSelectionOptions (AG Grid v33+)
    this.rowSelection = {
      mode: isMultiple ? 'multiRow' : 'singleRow',
      enableClickSelection: true,

      // ✅ esto controla si aparece checkbox en la primera columna
      checkboxes: this.enableCheckboxSelection,

      // ✅ solo tiene sentido en multi
      headerCheckbox: isMultiple && this.enableCheckboxSelection
    };
  }
  


  // ==============================
  // EVENTS
  // ==============================

  onGridReady(params: any): void {
    this.gridApi = params.api;

    setTimeout(() => {
      this.gridApi.autoSizeAllColumns();
    }, 0);
  }

  onRowSelectedEvent(event: any): void {
    if (event.node.selected) {
      this.rowSelected.emit(event.data);
    }
  }

  onSelectionChangedEvent(): void {
    if (this.selectionMode === 'multiple' && this.gridApi) {
      const selected = this.gridApi.getSelectedRows();
      this.selectionChanged.emit(selected);
    }
  }
}
