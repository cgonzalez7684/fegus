import { Component } from '@angular/core';
import { NgStyle } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import {
  ButtonDirective,
  CardBodyComponent,
  CardComponent,
  CardHeaderComponent,
  ColComponent,
  ColDirective,
  FormControlDirective,
  FormDirective,
  FormLabelDirective,
  GutterDirective,
  RowComponent,
  RowDirective,
  ButtonCloseDirective,  
  ModalBodyComponent,
  ModalComponent,
  ModalFooterComponent,
  ModalHeaderComponent,
  ModalTitleDirective,
  ModalToggleDirective,
  TableDirective,
  TableColorDirective
} from '@coreui/angular';
import { DocsComponentsComponent, DocsExampleComponent } from '@docs-components/public-api';
import { NgbDatepickerModule, NgbDateStruct } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-form-controls',
  templateUrl: './form-controls.component.html',
  styleUrls: ['./form-controls.component.scss'],
  imports: [RowComponent, ColComponent, CardComponent, CardHeaderComponent, CardBodyComponent, DocsExampleComponent, ReactiveFormsModule, FormsModule, FormDirective, FormLabelDirective, FormControlDirective, ButtonDirective, NgStyle, RowDirective, GutterDirective, ColDirective, DocsComponentsComponent, NgbDatepickerModule,    
    ModalToggleDirective,
    ModalComponent,
    ModalHeaderComponent,
    ModalTitleDirective,
    ButtonCloseDirective,
    ModalBodyComponent,
    ModalFooterComponent,
    TableDirective, TableColorDirective
  ]
})
export class FormControlsComponent {

  public favoriteColor = '#26ab3c';
  model: NgbDateStruct | undefined;

  constructor() {
    const today = new Date();
    this.model = {
      year: today.getFullYear(),
      month: today.getMonth() + 1, // ¡Ojo! getMonth() devuelve 0-11
      day: today.getDate()
    };
  }

  abrirModal(){
    console.log('Modal abierto');
  }

   onDateChange(date: NgbDateStruct) {
    console.log('Fecha seleccionada:', date);
    // Si querés mostrarla como string:
    if (date) {
      const fecha = `${date.day}/${date.month}/${date.year}`;
      console.log('Formato dd/mm/yyyy:', fecha);
    }
  }


}
