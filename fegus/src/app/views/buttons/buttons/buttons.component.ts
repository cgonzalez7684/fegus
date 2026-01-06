import { Component, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { ButtonDirective, CardBodyComponent, CardComponent, CardHeaderComponent, ColComponent, RowComponent } from '@coreui/angular';
import { IconDirective } from '@coreui/icons-angular';
import { DocsComponentsComponent, DocsExampleComponent } from '@docs-components/public-api';
import { ApiService } from '../../../services/services/api.service';
import { DeudorDto } from '../../../core/dtos/deudor.dto';
import { DeudorValue } from '../../../core/dtos/DeudorValue.dto';
import { ApiResponse } from '../../../core/dtos/api-response.dto';

@Component({
  selector: 'app-buttons',
  templateUrl: './buttons.component.html',
  imports: [RowComponent, ColComponent, CardComponent, CardHeaderComponent, CardBodyComponent, DocsExampleComponent, ButtonDirective, IconDirective, RouterLink, DocsComponentsComponent]
})
export class ButtonsComponent {

  private apiService = inject(ApiService);
  deudorData: ApiResponse<DeudorDto> | null = null;

  states = ['normal', 'active', 'disabled'];
  colors = ['primary', 'secondary', 'success', 'danger', 'warning', 'info', 'light', 'dark'];

   consumirAPI(): void {
    this.apiService.getDeudor().subscribe({
      next: response => {
        if (response.isSuccess) {
          this.deudorData = response;
          console.log('Respuesta API recibida:', this.deudorData.value.pDeudorDto.idDeudor);

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

}
