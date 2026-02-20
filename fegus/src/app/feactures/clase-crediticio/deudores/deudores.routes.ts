import { Routes } from '@angular/router';
import { AuthGuard } from '../../../core/auth/auth.guard';

export const routes: Routes = [   
  {
    path: '',
    data: {
      title: 'Crediticio'
    },
    canActivate: [AuthGuard],
    children: [     
      {
        path: 'deudores/gestion-datos',
        loadComponent: () => import('./pages/gestion-datos/gestion-datos.component').then(m => m.GestionDatosComponent),
        data: {
          title: 'Gestion de datos'
        }
      }
    ]
  },
  {
        path: '**',
        redirectTo: '/'
        
  }
]