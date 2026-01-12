import { ApplicationConfig } from '@angular/core';
import { provideAnimationsAsync } from '@angular/platform-browser/animations/async';
import {
  provideRouter,
  withEnabledBlockingInitialNavigation,
  withHashLocation,
  withInMemoryScrolling,
  withRouterConfig,
  withViewTransitions
} from '@angular/router';
import { IconSetService } from '@coreui/icons-angular';
import { routes } from './app.routes';
import { provideHttpClient,withInterceptors,withInterceptorsFromDi,HTTP_INTERCEPTORS } from '@angular/common/http';

import {
  MSAL_INSTANCE,
  MSAL_GUARD_CONFIG,
  MSAL_INTERCEPTOR_CONFIG,
  MsalGuardConfiguration,
  MsalInterceptorConfiguration,
  MsalService,
  MsalGuard,
  MsalInterceptor,
  MsalBroadcastService
} from '@azure/msal-angular';

import {
  IPublicClientApplication,
  PublicClientApplication,
  InteractionType
} from '@azure/msal-browser';
//import { environment } from 'src/environments/environment';
import { environment } from '../environments/environment';
import { msalConfig } from './core/auth/msal-config';


/* =========================
   MSAL INSTANCE
   ========================= */
export function msalInstanceFactory(): IPublicClientApplication {
  return new PublicClientApplication(msalConfig);
}

/* =========================
   MSAL GUARD CONFIG
   ========================= */
export function msalGuardConfigFactory(): MsalGuardConfiguration {
  return {
    interactionType: InteractionType.Redirect,
    authRequest: {
      scopes: [environment.ApiAZScope, 'openid', 'profile', 'email']
    }
  };
}

/* =========================
   MSAL INTERCEPTOR CONFIG
   ========================= */
export function msalInterceptorConfigFactory(): MsalInterceptorConfiguration {
  const protectedResourceMap = new Map<string, string[]>();

  /*protectedResourceMap.set(    
    'https://appfeguscgr-evakfaanbbc3cwaf.canadacentral-01.azurewebsites.net', // 👈 URL de tu API
    ['api://TU_API_CLIENT_ID/access_as_user']
  );*/

  protectedResourceMap.set(    
    environment.baseUrl, 
    [environment.ApiAZScope]
  );

  return {
    interactionType: InteractionType.Redirect,
    protectedResourceMap
  };
}

export const appConfig: ApplicationConfig = {
  providers: [
    provideRouter(routes,
      withRouterConfig({
        onSameUrlNavigation: 'reload'
      }),
      withInMemoryScrolling({
        scrollPositionRestoration: 'top',
        anchorScrolling: 'enabled'
      }),
      withEnabledBlockingInitialNavigation(),
      withViewTransitions(),
      withHashLocation()
    
    ),
    IconSetService,
    provideAnimationsAsync(),
    provideHttpClient(
      withInterceptorsFromDi()
    ),
    // MSAL core
    {
      provide: MSAL_INSTANCE,
      useFactory: msalInstanceFactory
    },
    {
      provide: MSAL_GUARD_CONFIG,
      useFactory: msalGuardConfigFactory
    },
    {
      provide: MSAL_INTERCEPTOR_CONFIG,
      useFactory: msalInterceptorConfigFactory
    },

    MsalService,
    //MsalGuard,
    MsalBroadcastService,

    {
      provide: HTTP_INTERCEPTORS,
      useClass: MsalInterceptor,
      multi: true
    }
  ]
};

