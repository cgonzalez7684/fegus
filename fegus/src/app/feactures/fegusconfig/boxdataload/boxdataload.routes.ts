import { Routes } from '@angular/router';
import { AuthGuard } from '../../../core/auth/auth.guard';

export const routes: Routes = [
  {
    path: '',
    data: {
      title: 'BoxDataLoad'
    },    
    canActivate: [AuthGuard],
    children: [
      {
        path: 'boxdataload/mant-boxdataload',
        loadComponent: () => import('./pages/mant-boxdataload/mant-boxdataload.component').then(m => m.MantBoxdataloadComponent),
        data: {
          title: 'Mant Box Data Load'
        }
      }     
    ]
  },
  {
        path: '**',
        redirectTo: '/'        
  }
]