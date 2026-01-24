import { Component } from '@angular/core';
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
  RowComponent
} from '@coreui/angular';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  imports: [ContainerComponent, RowComponent, ColComponent, CardGroupComponent, CardComponent, CardBodyComponent, FormDirective, InputGroupComponent, InputGroupTextDirective, IconDirective, FormControlDirective, ButtonDirective, NgStyle]
})
export class LoginComponent {

  loading = false;
  errorMessage?: string;

  constructor(
    private authService: AuthLocalService,
    private router: Router
  ) {}

  login(email: string, password: string): void {

    // Validación mínima
    if (!email || !password) {
      this.errorMessage = 'Email and password are required';
      return;
    }

    this.loading = true;
    this.errorMessage = undefined;
    const dataAccess = {idCliente : 1001, username: email!, password: password!};


    this.authService.login(dataAccess).subscribe({
      next: () => {
        this.router.navigate(['/dashboard']);
      },
      error: () => {
        this.errorMessage = 'Invalid email or password';
        this.loading = false;
      }
    });
  }
}
