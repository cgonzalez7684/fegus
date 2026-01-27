import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { environment } from '../../../environments/environment';
import { tap, map, finalize } from 'rxjs/operators';
import { ApiResult, LoginResponse } from './auth.model';
import { Observable } from 'rxjs/internal/Observable';

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
          this.setTokens(tokens.accessToken, tokens.refreshToken);          
        })
      );
  }

  

  logout(): Observable<void> {
    const refreshToken = localStorage.getItem(this.REFRESH_TOKEN_KEY);

    //Se elimina localmente los tokens antes de hacer la llamada al backend
    this.clear()

    return this.http.post<void>(
      `${environment.baseUrl}/auth/logout`,
      { refreshToken }
    ).pipe(
      finalize(() => {
        localStorage.removeItem(this.ACCESS_TOKEN_KEY);
        localStorage.removeItem(this.REFRESH_TOKEN_KEY);
      })
    );
  }

  setTokens(access: string, refresh: string): void {
    localStorage.setItem(this.ACCESS_TOKEN_KEY, access);
    localStorage.setItem(this.REFRESH_TOKEN_KEY, refresh);
  }
  
  getRefreshToken(): string | null {
    return localStorage.getItem(this.REFRESH_TOKEN_KEY);
  }

  getAccessToken(): string | null {
    return localStorage.getItem(this.ACCESS_TOKEN_KEY);
  }

  isAuthenticated(): boolean {
    return !!this.getAccessToken();
  }

  clear(): void {
    localStorage.removeItem(this.ACCESS_TOKEN_KEY);
    localStorage.removeItem(this.REFRESH_TOKEN_KEY);
  }

}
