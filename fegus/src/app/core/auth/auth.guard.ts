import { inject, Injectable } from '@angular/core';
import { CanActivate, CanActivateFn, Router } from '@angular/router';
import { AuthLocalService } from './authlocal.service';
import { JwtHelperService } from '@auth0/angular-jwt';

@Injectable({ providedIn: 'root' })
export class AuthGuard implements CanActivate {

  constructor(
    private auth: AuthLocalService,
    private router: Router
  ) {}

  canActivate(): boolean {
    if (!this.auth.isAuthenticated()) {
      this.router.navigate(['/']);
      return false;
    }

    const helper = new JwtHelperService();
    if (helper.isTokenExpired(this.auth.getAccessToken()!)) {
      this.router.navigate(['/']);
      return false;
    }

    return true;
  }
}
