import { Injectable } from '@angular/core';
import {
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
  HttpErrorResponse,
  HttpClient
} from '@angular/common/http';
import { BehaviorSubject, Observable, throwError } from 'rxjs';
import { catchError, filter, switchMap, take } from 'rxjs/operators';
import { Router } from '@angular/router';
import { AuthLocalService } from './authlocal.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  private isRefreshing = false;
  private refreshSubject = new BehaviorSubject<string | null>(null);

  constructor(
    private authLocalService: AuthLocalService,
    private http: HttpClient,
    private router: Router
  ) {}

  intercept(
    req: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {

    const token = this.authLocalService.getAccessToken();

    const authReq = token
      ? req.clone({ setHeaders: { Authorization: `Bearer ${token}` } })
      : req;  

    return next.handle(authReq).pipe(
      catchError((error: HttpErrorResponse) => {

        if (error.status === 401) {
          return this.handle401(authReq, next);
        }

        return throwError(() => error);
      })
    );
  }

  private handle401(req: HttpRequest<any>, next: HttpHandler) {

    if (!this.isRefreshing) {
      this.isRefreshing = true;
      this.refreshSubject.next(null);

      const refreshToken = this.authLocalService.getRefreshToken();
      if (!refreshToken) {
        this.forceLogout();
        return throwError(() => 'No refresh token');
      }

      return this.http.post<any>(
        '/auth/refresh',
        { refreshToken }
      ).pipe(
        switchMap(res => {
          this.isRefreshing = false;

          const access = res.value.accessToken;
          const refresh = res.value.refreshToken;

          this.authLocalService.setTokens(access, refresh);
          this.refreshSubject.next(access);

          return next.handle(
            req.clone({
              setHeaders: { Authorization: `Bearer ${access}` }
            })
          );
        }),
        catchError(() => {
          this.isRefreshing = false;
          this.forceLogout();
          return throwError(() => 'Refresh failed');
        })
      );
    }

    // Si ya hay refresh en curso
    return this.refreshSubject.pipe(
      filter(token => token !== null),
      take(1),
      switchMap(token =>
        next.handle(
          req.clone({
            setHeaders: { Authorization: `Bearer ${token}` }
          })
        )
      )
    );
  }

  private forceLogout() {
    // 1️⃣ Limpiar tokens
    this.authLocalService.logout();

    // 2️⃣ Redirigir a login
    this.router.navigate(['/login']);
  }

}
