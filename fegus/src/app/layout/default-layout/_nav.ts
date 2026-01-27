import { INavData } from '@coreui/angular';

export const navItems: INavData[] = [
 /* {
    name: 'Dashboard',
    url: '/dashboard',
    iconComponent: { name: 'cil-speedometer' },
    badge: {
      color: 'info',
      text: 'NEW'
    }
  },*/
  {
    title: true,
    name: 'Administración'
  },
  {
    name: 'Usuarios',
    url: '/theme/colors',
    iconComponent: { name: 'cil-drop' }
  },
  {
    name: 'Parametros',
    url: '/theme/typography',
    linkProps: { fragment: 'headings' },
    iconComponent: { name: 'cil-pencil' }
  },
  {
    name: 'Clase de datos Credito',
    title: true
  },
  {
    name: 'Deudores',
    url: '/base',
    iconComponent: { name: 'cil-puzzle' },
    children: [
      {
        name: 'Configuraciones',
        url: '/base/accordion',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Mantenimientos',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Validaciones',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: 'https://coreui.io/angular/docs/components/calendar/',
        icon: 'nav-icon-bullet'      
      },
      {
        name: 'Aprobacion de cambios',
        url: '/base/cards',
        icon: 'nav-icon-bullet'
      }
      
    ]
  },
  {
    name: 'Creditos',
    iconComponent: { name: 'cil-star' },
    url: '/icons',
    children: [
      {
        name: 'Configuraciones',
        url: '/base/accordion',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Mantenimientos',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Validaciones',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: 'https://coreui.io/angular/docs/components/calendar/',
        icon: 'nav-icon-bullet'      
      },
      {
        name: 'Aprobacion de cambios',
        url: '/base/cards',
        icon: 'nav-icon-bullet'
      }
    ]
  },
  {
    name: 'Garantias',
    url: '/notifications',
    iconComponent: { name: 'cil-bell' },
    children: [
      {
        name: 'Configuraciones',
        url: '/base/accordion',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Mantenimientos',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Validaciones',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: 'https://coreui.io/angular/docs/components/calendar/',
        icon: 'nav-icon-bullet'      
      },
      {
        name: 'Aprobacion de cambios',
        url: '/base/cards',
        icon: 'nav-icon-bullet'
      }
    ]
  },
  
  {
    name: 'Charts',
    iconComponent: { name: 'cil-chart-pie' },
    url: '/charts'
  },
  {
    title: true,
    name: 'Reportes'
  },
  {
    name: 'Mensual',
    url: '/login',
    iconComponent: { name: 'cil-star' },
    children: [
      {
        name: 'Estimación',
        url: '/login',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Mitigadores',
        url: '/register',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Segmentos',
        url: '/404',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Cartera SBD',
        url: '/500',
        icon: 'nav-icon-bullet'
      }
    ]
  },
  {
    title: true,
    name: 'Links',
    class: 'mt-auto'
  },
  {
    name: 'Docs',
    url: 'https://coreui.io/angular/docs/',
    iconComponent: { name: 'cil-description' },
    attributes: { target: '_blank' }
  }
];
