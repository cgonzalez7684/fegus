import { Component, DestroyRef, inject, OnInit } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { Title } from '@angular/platform-browser';
import { ActivatedRoute, NavigationEnd, Router, RouterOutlet } from '@angular/router';
import { delay, filter, map, tap } from 'rxjs/operators';

import { ColorModeService } from '@coreui/angular';
import { IconSetService } from '@coreui/icons-angular';
import { iconSubset } from './icons/icon-subset';
import { MsalService } from '@azure/msal-angular';
import { AuthService } from './core/services/auth.service';



@Component({
    selector: 'app-root',
    template: '<router-outlet />',
    imports: [RouterOutlet]
})
export class AppComponent implements OnInit {
  title = 'Sistema de Gestión FEGUS';

  readonly #destroyRef: DestroyRef = inject(DestroyRef);
  readonly #activatedRoute: ActivatedRoute = inject(ActivatedRoute);
  readonly #router = inject(Router);
  readonly #titleService = inject(Title);

  readonly #colorModeService = inject(ColorModeService);
  readonly #iconSetService = inject(IconSetService);

  constructor(private msalService: MsalService, private authService: AuthService) {
    this.#titleService.setTitle(this.title);
    // iconSet singleton
    this.#iconSetService.icons = { ...iconSubset };
    this.#colorModeService.localStorageItemName.set('coreui-free-angular-admin-template-theme-default');
    this.#colorModeService.eventName.set('ColorSchemeChange');
  }

  async ngOnInit(): Promise<void> {
  

    this.#router.events.pipe(
        takeUntilDestroyed(this.#destroyRef)
      ).subscribe((evt) => {
      if (!(evt instanceof NavigationEnd)) {
        return;
      }
    });

    this.#activatedRoute.queryParams
      .pipe(
        delay(1),
        map(params => <string>params['theme']?.match(/^[A-Za-z0-9\s]+/)?.[0]),
        filter(theme => ['dark', 'light', 'auto'].includes(theme)),
        tap(theme => {
          this.#colorModeService.colorMode.set(theme);
        }),
        takeUntilDestroyed(this.#destroyRef)
      )
      .subscribe();

    //await this.msalService.instance.initialize();

     // 2️⃣ PROCESAR EL RESULTADO DEL REDIRECT (CLAVE)
    const result = await this.msalService.instance.handleRedirectPromise();

    //this.authService.setActiveAccount();  
    if (result?.account) {
      // 3️⃣ Establecer cuenta activa
      this.msalService.instance.setActiveAccount(result.account);
      await this.#router.navigateByUrl('/dashboard');
      console.log('Active account:',this.msalService.instance.getActiveAccount());
      return;

    } 

    // Si ya había sesión previa (ej: refresh)
    const accounts = this.msalService.instance.getAllAccounts();
    if (accounts.length > 0) {
      this.msalService.instance.setActiveAccount(accounts[0]);
    }


  }
}
