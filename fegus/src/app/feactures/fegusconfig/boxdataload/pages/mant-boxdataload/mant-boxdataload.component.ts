import { Component, ViewChild, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { GridZComponent } from '../../../../../shared/components/grid-z/grid-z.component';
import { BOXDATALOAD_GRID_CONFIG } from '../../models/boxdataload.grid.config';
import { BoxDataLoadApiService } from '../../services/boxdataload-api.services';
import { BoxDataLoadDto } from '../../models/BoxDataLoad.dto';
import { ApiResponse } from '../../../../../core/dtos/api-response.dto';
import { BoxDataLoadValue } from '../../models/BoxDataLoadValue.dto';
import { FormsModule } from '@angular/forms';
import { finalize } from 'rxjs';
import { ToastService } from '../../../../../services/toast.service';
import { ButtonDirective,
  ColComponent,  
  CardBodyComponent,
  CardComponent,
  CardHeaderComponent,  
  RowComponent,
  ButtonCloseDirective,
  ModalBodyComponent,
  ModalComponent,
  ModalFooterComponent,
  ModalHeaderComponent,
  ModalTitleDirective,
  ModalToggleDirective
 } from '@coreui/angular';


@Component({
  selector: 'app-mant-boxdataload',
  standalone: true,
  imports: [CommonModule,FormsModule,GridZComponent,CardBodyComponent, CardComponent, CardHeaderComponent, ColComponent, RowComponent,ButtonDirective,
    ButtonCloseDirective, ModalBodyComponent, ModalComponent, ModalFooterComponent, ModalHeaderComponent, ModalTitleDirective, ModalToggleDirective
  ],
  templateUrl: './mant-boxdataload.component.html',
  styleUrl: './mant-boxdataload.component.scss',
})
export class MantBoxdataloadComponent {

  constructor(private apiService:BoxDataLoadApiService){}
  private toastService = inject(ToastService);
  listaboxdataload: ApiResponse<BoxDataLoadValue<BoxDataLoadDto[]>> | null = null;
  rowData: BoxDataLoadDto[] = [];  // Aquí se almacenarán los datos para la grilla
  columns = BOXDATALOAD_GRID_CONFIG
  @ViewChild('verticallyCenteredModal') modal!: ModalComponent;

  modalVisible = false;
  creating = false;
  createError: string | null = null;
  createCommand: { idCliente: number; stateCode: string; isActive: string; asofDate: string | null } = {
    idCliente: 1001,
    stateCode: 'NEW',
    isActive: 'Y',
    asofDate: null
  };

  GetBoxDataLoad(): void {
    
    /*this.apiService.GetBoxDataLoad('1001').subscribe(response => {

      console.log("RESPUESTA RAW:");
      console.log(JSON.stringify(response, null, 2));

    });*/

    this.apiService.GetBoxDataLoad('1001').subscribe({
      next: response => {
        if (response.isSuccess) {
          console.log('Ingreso a GetBoxDataLoad2');
          //this.rowData = response.value?.result ? [response.value.result] : [];
          this.rowData = response.value ?? [];
          console.log('Datos obtenidos:', this.rowData);
          
        }else {
          console.error('Error lógico:', response.error);
        }
      }
    });
  }

  openCreateModal(): void {
    this.createError = null;
    this.creating = false;
    this.createCommand = {
      idCliente: 1001,
      stateCode: 'NEW',
      isActive: 'Y',
      asofDate: null
    };
    this.modalVisible = true;
  }

  onModalVisibleChange(visible: boolean): void {
    const wasVisible = this.modalVisible;
    this.modalVisible = visible;

    // Al cerrar el modal, refrescamos el grid
    if (wasVisible && !visible) {
      this.GetBoxDataLoad();
    }
  }

  createBoxDataLoad(): void {
    this.createError = null;
    this.creating = true;

    this.apiService.postCreateBoxDataLoad({
      idCliente: this.createCommand.idCliente,
      stateCode: this.createCommand.stateCode,
      isActive: this.createCommand.isActive,
      asofDate: this.createCommand.asofDate
    }).pipe(
      finalize(() => {
        this.creating = false;
      })
    ).subscribe({
      next: res => {
        const anyRes: any = res as any;
        const rawIsSuccess: boolean | undefined = anyRes?.isSuccess ?? anyRes?.IsSuccess;
        const errorMsg: string | null = anyRes?.error ?? anyRes?.Error ?? null;
        const rawValue = anyRes?.value ?? anyRes?.Value ?? null;

        // Fallback: si el backend no respeta el contrato ApiResponse, inferimos éxito
        const isSuccess: boolean =
          rawIsSuccess === true ||
          (rawIsSuccess === undefined && !errorMsg && rawValue !== null);

        if (isSuccess) {
          // Cerramos el modal sí o sí (algunas versiones requieren hide())
          this.modalVisible = false;
          (this.modal as any)?.hide?.();
          this.GetBoxDataLoad();
          this.toastService.success('Carga creada correctamente.');
        } else {
          const msg = errorMsg ?? 'No se pudo crear la carga.';
          this.createError = msg;
          this.toastService.error(msg);
        }
      },
      error: err => {
        const msg = err?.error?.error ?? err?.error?.Error ?? err?.message ?? 'Error HTTP al crear la carga.';
        this.createError = msg;
        this.toastService.error(msg);
      }
    });
  }

onSelectionChanged(selected: BoxDataLoadDto[]): void {
    console.log('Filas seleccionadas:', selected);
  }

   onRowSelected(event: any): void {
    console.log('llegaaaa');
    if (event.node.selected) {
      console.log('Fila seleccionada:', event.data);
    }
  }

  onCellChanged(event: any) {
    console.log('Valor anterior:', event.oldValue);
    console.log('Valor nuevo:', event.newValue);
    console.log('Fila afectada:', event.data);
  }

  ngOnInit() {
    //this.consumirAPI();
    this.GetBoxDataLoad();
    
  }


}
