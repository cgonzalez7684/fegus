import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { environment } from '../../../environments/environment';
import { tap, map } from 'rxjs/operators';
import { ApiResult, LoginResponse } from './auth.model';

@Injectable({ providedIn: 'root' })
export class AuthLocalService {

  private readonly ACCESS_TOKEN_KEY = 'fegus_access_token';
  private readonly REFRESH_TOKEN_KEY = 'fegus_refresh_token';

  constructor(
    private http: HttpClient,
    private router: Router
  ) {}

  login(data: { idCliente : number; username: string; password: string }) {
    return this.http
      .post<ApiResult<LoginResponse>>(
        `${environment.baseUrl}/auth/login`,
        data
      )
      .pipe(
        map(res => {
          if (!res.isSuccess || !res.value) {
            throw new Error(res.error ?? 'Login failed');
          }
          return res.value;
        }),
        tap(tokens => {
          localStorage.setItem(this.ACCESS_TOKEN_KEY, tokens.accessToken);
          localStorage.setItem(this.REFRESH_TOKEN_KEY, tokens.refreshToken);
        })
      );
  }

  logout(): void {
    localStorage.removeItem(this.ACCESS_TOKEN_KEY);
    localStorage.removeItem(this.REFRESH_TOKEN_KEY);
    this.router.navigate(['/login']);
  }

  getAccessToken(): string | null {
    return localStorage.getItem(this.ACCESS_TOKEN_KEY);
  }

  isAuthenticated(): boolean {
    return !!this.getAccessToken();
  }
}
