import { Injectable } from '@angular/core';
import {
  HttpEvent,
  HttpHandler,
  HttpInterceptor,
  HttpRequest,
  HttpErrorResponse
} from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { Router } from '@angular/router';
import { AuthLocalService } from './authlocal.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {

  constructor(
    private authLocalService: AuthLocalService,
    private router: Router
  ) {}

  intercept(
    req: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {

    const token = this.authLocalService.getAccessToken();

    let authReq = req;

    // 🔐 Adjuntar token si existe
    if (token) {
      authReq = req.clone({
        setHeaders: {
          Authorization: `Bearer ${token}`
        }
      });
    }

    return next.handle(authReq).pipe(
      catchError((error: HttpErrorResponse) => {

        // 🚨 AQUÍ VA EXACTAMENTE LO QUE TE COMENTÉ
        if (error.status === 401) {
          console.warn('Token expirado o inválido. Cerrando sesión.');

          // 1️⃣ Limpiar tokens
          this.authLocalService.logout();

          // 2️⃣ Redirigir a login
          this.router.navigate(['/login']);
        }

        return throwError(() => error);
      })
    );
  }
}
