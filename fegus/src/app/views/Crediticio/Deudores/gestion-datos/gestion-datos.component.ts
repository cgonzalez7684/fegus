import { Component } from '@angular/core';
import { ColDef } from 'ag-grid-community';
import { GridZComponent } from '../../../../components/grid-z/grid-z.component';


import {  
  CardBodyComponent,
  CardComponent,
  CardHeaderComponent,
  ColComponent,
  RowComponent  
  
} from '@coreui/angular';


@Component({
  selector: 'app-gestion-datos',
  standalone: true,
  imports: [GridZComponent, CardBodyComponent, CardComponent, CardHeaderComponent, ColComponent, RowComponent],
  templateUrl: './gestion-datos.component.html',
  styleUrl: './gestion-datos.component.scss',
})
export class GestionDatosComponent {

columnDefs: ColDef[] = [
    { headerName: 'Id Cliente', field: 'idCliente' },
    { headerName: 'Id Deudor', field: 'idDeudor' },
    { headerName: 'Sector Económico', field: 'codigoSectorEconomico' },
    { headerName: 'Ingreso Total', field: 'montoIngresoTotalDeudor', filter: 'agNumberColumnFilter' }
  ];

  rowData = [
    {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
    {
      idCliente: 1,
      idDeudor: '987654321',
      codigoSectorEconomico: 205,
      montoIngresoTotalDeudor: 4000000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    },
     {
      idCliente: 1,
      idDeudor: '123456789',
      codigoSectorEconomico: 101,
      montoIngresoTotalDeudor: 2500000
    }
  ];

  onRowSelected(row: any) {
    console.log('Fila seleccionada:', row);
  }

  ngOnInit() {
  console.log('Datos:', this.rowData);
  }
}

   


