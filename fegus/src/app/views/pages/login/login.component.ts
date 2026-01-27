import { Component, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { AuthLocalService } from '../../../core/auth/authlocal.service';
import { NgStyle } from '@angular/common';
import { IconDirective } from '@coreui/icons-angular';
import {
  ButtonDirective,
  CardBodyComponent,
  CardComponent,
  CardGroupComponent,
  ColComponent,
  ContainerComponent,
  FormControlDirective,
  FormDirective,
  InputGroupComponent,
  InputGroupTextDirective,
  RowComponent, 
  ToastBodyComponent,
  ToastComponent,
  ToasterComponent,
  ToastHeaderComponent
} from '@coreui/angular';

import { ToastService } from '../../../services/toast.service';


@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  standalone: true,
  imports: [ContainerComponent, RowComponent, ColComponent, CardGroupComponent, 
    CardComponent, CardBodyComponent, FormDirective, 
    InputGroupComponent, InputGroupTextDirective, IconDirective, 
    FormControlDirective, ButtonDirective, NgStyle,
    ToasterComponent,
    ToastComponent,
    ToastHeaderComponent,
    ToastBodyComponent    
  ]
})
export class LoginComponent {
 
  toasterService = inject(ToastService);
  
  loading = signal(false);
  errorMessage?: string;
  
  
 

  constructor(
    private authService: AuthLocalService,
    private router: Router
    //private toasterService: ToastService
  ) {}

 

   
 

  login(email: string, password: string): void {

    // Validación mínima
    if (!email || !password) {
      this.errorMessage = 'User and password are required';
      this.loading.set(false);
      return;
    }

    this.loading.set(true);
    this.errorMessage = undefined;
    const dataAccess = {idCliente : 1001, username: email!, password: password!};

   

    this.authService.login(dataAccess).subscribe({
      next: () => {
        this.loading.set(false); 
        this.router.navigate(['/dashboard']);
      },
      error: () => {
        
        console.log('Login error');
        this.errorMessage = 'Invalid email or password';
        this.loading.set(false); 
        this.toasterService.error('Login fallido: Invalid email or password'); 
        //alert('Login failed: Invalid email or password');      
        
      }
    });
  }


  
 
}
