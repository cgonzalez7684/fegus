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
    name: 'Integración de datos',
    title: true
  },
  {
    name: 'Carga de datos',
    url: '/base',
    iconComponent: { name: 'cil-puzzle' }   
  },
  {
    name: 'Clase de datos Credito',
    title: true
  },
  {
    name: 'Deudores',
    url: '/crediticio',
    iconComponent: { name: 'cil-puzzle' },
    children: [
      {
        name: 'Gestión de datos',
        url: '/crediticio/deudores/gestion-datos',
        icon: 'nav-icon-bullet'        
      },
      {
        name: 'Validaciones Sugef',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Gestión de cambios',
        url: '/base/breadcrumbs',
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
    name: 'CLASE DE DATOS GARANTIAS'
  },
  {
    name: 'Polizas',
    url: '/base',
    iconComponent: { name: 'cil-puzzle' },
    children: [
      {
        name: 'Gestión de datos',
        url: '/base/accordion',
        icon: 'nav-icon-bullet'        
      },
      {
        name: 'Validaciones Sugef',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Gestión de cambios',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'      
      }      
      
    ],
    
  },
  {
    name: 'Cartas Crédito',
    url: '/base',
    iconComponent: { name: 'cil-puzzle' },
    children: [
      {
        name: 'Gestión de datos',
        url: '/base/accordion',
        icon: 'nav-icon-bullet'        
      },
      {
        name: 'Validaciones Sugef',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Gestión de cambios',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'      
      }      
      
    ],
    
  },
  {
    name: 'Facturas Cedidas',
    url: '/base',
    iconComponent: { name: 'cil-puzzle' },
    children: [
      {
        name: 'Gestión de datos',
        url: '/base/accordion',
        icon: 'nav-icon-bullet'        
      },
      {
        name: 'Validaciones Sugef',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Gestión de cambios',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'      
      }      
      
    ],
    
  },
  {
    name: 'Fiduciarias',
    url: '/base',
    iconComponent: { name: 'cil-puzzle' },
    children: [
      {
        name: 'Gestión de datos',
        url: '/base/accordion',
        icon: 'nav-icon-bullet'        
      },
      {
        name: 'Validaciones Sugef',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Gestión de cambios',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'      
      }      
      
    ],
    
  },
  {
    name: 'Reales',
    url: '/base',
    iconComponent: { name: 'cil-puzzle' },
    children: [
      {
        name: 'Gestión de datos',
        url: '/base/accordion',
        icon: 'nav-icon-bullet'        
      },
      {
        name: 'Validaciones Sugef',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Gestión de cambios',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'      
      }      
      
    ],
    
  },
  {
    name: 'Valores',
    url: '/base',
    iconComponent: { name: 'cil-puzzle' },
    children: [
      {
        name: 'Gestión de datos',        
        icon: 'nav-icon-bullet'             
      },
      {
        name: 'Validaciones Sugef',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Generación de XML',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'
      },
      {
        name: 'Gestión de cambios',
        url: '/base/breadcrumbs',
        icon: 'nav-icon-bullet'      
      }      
      
    ],
    
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
