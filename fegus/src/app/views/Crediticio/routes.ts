import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    data: {
      title: 'Crediticio'
    },
    children: [
      {
        path: '',
        redirectTo: 'crediticio',
        pathMatch: 'full'
      },
      {
        path: 'deudores/gestion-datos',
        loadComponent: () => import('./Deudores/gestion-datos/gestion-datos.component').then(m => m.GestionDatosComponent),
        data: {
          title: 'Gestion de datos'
        }
      }
    ]
}
]