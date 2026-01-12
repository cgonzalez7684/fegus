import { Component, OnDestroy, OnInit } from '@angular/core';
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

//import { MsalService } from '@azure/msal-angular';
//import { AuthService } from './core/services/auth.service';
import { AuthService } from '../../../core/services/auth.service';
import { MsalBroadcastService } from '@azure/msal-angular';
import { InteractionStatus } from '@azure/msal-browser';
import { Subject,takeUntil } from 'rxjs';
import { filter } from 'rxjs/operators';
import { Router } from '@angular/router';

@Component({
  selector: 'app-login',
  standalone: true,
  templateUrl: './login.component.html',
  imports: [ContainerComponent, RowComponent, ColComponent, CardGroupComponent, CardComponent, CardBodyComponent, FormDirective, InputGroupComponent, InputGroupTextDirective, IconDirective, FormControlDirective, ButtonDirective]
})
export class LoginComponent implements OnDestroy, OnInit {


  isInteractionInProgress = false;
  private destroy$ = new Subject<void>();
  
  constructor(private authService: AuthService,
              private msalBroadcast: MsalBroadcastService,
              private router: Router
  ) { 
    

    this.msalBroadcast.inProgress$
      .pipe(
        filter(status => status === InteractionStatus.None),
        takeUntil(this.destroy$)
      )
      .subscribe(() => {
        //cuando NO hay interacción, habilita botón
        this.isInteractionInProgress = false;
      });

    // Escuchar el estado de interacción
    this.msalBroadcast.inProgress$
      .pipe(filter(status => status !== InteractionStatus.None),
        takeUntil(this.destroy$)
      )
      .subscribe(() => {
        
        this.isInteractionInProgress = true;
      });
   
  }

  ngOnInit(): void {
    //this.authService.setActiveAccount();
    // 🔑 SI YA ESTÁ AUTENTICADO → IR AL DASHBOARD
    if (this.authService.isAuthenticated()) {
      this.router.navigateByUrl('dashboard');
      
    }
    


  }

  loginWithMicrosoft(): void {

    sessionStorage.removeItem('msal.interaction.status');

    /*if (this.isInteractionInProgress) {
      console.log('Interacción en progreso, espere...');
      return; // evita doble login
    }*/

    this.authService.login();
  }

  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();
  }

}
