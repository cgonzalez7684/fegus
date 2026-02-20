import { Component } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ButtonDirective,
  ColComponent,  
  CardBodyComponent,
  CardComponent,
  CardHeaderComponent,  
  RowComponent  
 } from '@coreui/angular';
import { ColDef } from 'ag-grid-community';
import { GridZComponent } from '../../../../../shared/components/grid-z/grid-z.component';
import { DeudorApiService } from '../../services/deudor-api.services';
import { DeudorDto } from '../../models/deudor.dto';
import { ApiResponse } from '../../../../../core/dtos/api-response.dto';
import { DeudorValue } from '../../models/DeudorValue.dto';
import { DEUDOR_GRID_CONFIG } from '../../models/deudor.grid.config';
import { FormsModule } from '@angular/forms';

//import { GridZComponent } from '@shared/components/grid-z/grid-z.component';


@Component({
  selector: 'app-gestion-datos',
  standalone: true,
  imports: [CommonModule,FormsModule,ButtonDirective,GridZComponent, CardBodyComponent, CardComponent, CardHeaderComponent, ColComponent, RowComponent],
  templateUrl: './gestion-datos.component.html',
  styleUrl: './gestion-datos.component.scss',
})
export class GestionDatosComponent {

  constructor(private apiService: DeudorApiService) {} 
  deudorData: ApiResponse<DeudorValue<DeudorDto>> | null = null;
  listadeudorData: ApiResponse<DeudorValue<DeudorDto[]>> | null = null;
  rowData: DeudorDto[] = [];
  columns = DEUDOR_GRID_CONFIG;
  idCliente: string = '';

  

  GetDeudor(): void {
    console.log('Botón "Consumir API" clickeado');
    this.apiService.getDeudor(this.idCliente, '782245869').subscribe({
      next: response => {
        if (response.isSuccess) {
          this.rowData = response.value?.result ? [response.value.result] : [];
          this.deudorData = response;
          console.log('Deudor cargado:', this.deudorData);
          console.log('Respuesta API recibida:', this.deudorData.value?.result);

          // Ejemplo: convertir fechas a Date si lo necesitas
         /* this.deudorData.fechaUltGestion = new Date(
            response.pDeudorDto.fechaUltGestion
          ).toISOString();*/

          //console.log('Deudor cargado:', this.deudorData);
        } else {
          console.error('Error lógico:', response.error);
        }
      },
      error: err => {
        console.error('Error HTTP:', err);
      }
    });
  
  }

  GetDeudores(): void {
    console.log('Botón "Consumir API GetDeudores" clickeado');
    this.apiService.getDeudores(this.idCliente).subscribe({
      next: response => {
        if (response.isSuccess) {
          this.rowData = response.value?.result || [];

          this.listadeudorData = response;
          console.log('Lista de deudores cargada:', this.listadeudorData);
          console.log('Respuesta API recibida:', this.listadeudorData.value?.result);

          // Ejemplo: convertir fechas a Date si lo necesitas
         /* this.deudorData.fechaUltGestion = new Date(
            response.pDeudorDto.fechaUltGestion
          ).toISOString();*/

          //console.log('Deudor cargado:', this.deudorData);
        } else {
          console.error('Error lógico:', response.error);
        }
      },
      error: err => {
        console.error('Error HTTP:', err);
      }
    });
  
  }

  onSelectionChanged(selected: DeudorDto[]): void {
    console.log('Filas seleccionadas:', selected);
  }

   onRowSelected(event: any): void {
    console.log('llegaaaa');
    if (event.node.selected) {
      console.log('Fila seleccionada:', event.data);
    }
  }

  ngOnInit() {
    //this.consumirAPI();
    console.log('Datos:', this.rowData);
  }
}

   


