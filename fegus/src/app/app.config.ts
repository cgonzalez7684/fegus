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




import { environment } from '../environments/environment';

import { AuthInterceptor } from './core/auth/auth.interceptor';



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
      withViewTransitions()
      //withHashLocation()
    
    ),
    IconSetService,
    provideAnimationsAsync(),
    provideHttpClient(
      withInterceptorsFromDi()
    ),    
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      //useClass: MsalInterceptor,
      multi: true
    }
  ]
};

