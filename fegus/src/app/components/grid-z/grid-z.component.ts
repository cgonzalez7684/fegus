import { Component, Input, Output, EventEmitter,OnChanges, SimpleChanges } from '@angular/core';
import { AgGridAngular } from 'ag-grid-angular';
import { ColDef, GridReadyEvent, themeBalham, themeQuartz } from 'ag-grid-community';
import { CommonModule } from '@angular/common';
import { GridApi } from 'ag-grid-community';


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

  @Output() rowSelected = new EventEmitter<any>();

 defaultColDef = {
  sortable: true,
  resizable: true,
  filter: true
};

  ngOnChanges(changes: SimpleChanges) {
    if (changes['rowData'] && this.gridApi) {
      this.gridApi.setGridOption('rowData', this.rowData);
    }
  }

  onGridReady(event: GridReadyEvent) {
    this.gridApi = event.api;
    event.api.sizeColumnsToFit();
    //console.log('ColumnDefs:', this.columnDefs);
    //console.log('RowData:', this.rowData);
  }

  onRowSelectedEvent(event: any) {
    if (event.node.selected) {
      this.rowSelected.emit(event.data);
    }
  }
}
