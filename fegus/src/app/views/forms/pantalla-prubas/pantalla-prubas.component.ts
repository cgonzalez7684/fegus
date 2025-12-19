import { Component } from '@angular/core';
import { FormGroup, FormControl, ReactiveFormsModule} from '@angular/forms';

@Component({
  selector: 'app-pantalla-prubas',
  imports: [ReactiveFormsModule],
  templateUrl: './pantalla-prubas.component.html',
  styleUrl: './pantalla-prubas.component.scss'
})
export class PantallaPrubasComponent {
  
  formularioCliente = new FormGroup(
    {
      identificacionCliente : new FormControl(''),
      nombreCliente : new FormControl(''),
      detalleCliente : new FormControl('')
    }

  );



}

