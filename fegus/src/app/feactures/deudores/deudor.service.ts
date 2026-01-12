import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { environment } from '../../../environments/environment';

@Injectable({ providedIn: 'root' })
export class DeudorService {

  constructor(private http: HttpClient) {}

  getDeudor(idCliente: number, idDeudor: string) {
    return this.http.get(
      `${environment.baseUrl}/deudores/${idCliente}/${idDeudor}`
    );
  }
}
