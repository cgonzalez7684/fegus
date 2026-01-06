import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs';
import { DeudorDto } from '../../core/dtos/deudor.dto';
import { ApiResponse } from '../../core/dtos/api-response.dto';
import { DeudorValue } from '../../core/dtos/DeudorValue.dto';

/*export interface ProductoDto {
  id: number;
  nombre: string;
  precio: number;
}*/

@Injectable({ providedIn: 'root' })
export class ApiService {
  private http = inject(HttpClient);
  private base = environment.apiUrl;

  // GET: api/productos
  /*getDeudor(): Observable<DeudorDto> {
    return this.http.get<DeudorDto>(`${this.base}`);
  }*/

  getDeudor(): Observable<ApiResponse<DeudorDto>> {
    return this.http.get<ApiResponse<DeudorDto>>(
      `${this.base}`
    );
  }

  // POST: api/productos
  /*crearProducto(dto: Omit<ProductoDto, 'id'>): Observable<ProductoDto> {
    return this.http.post<ProductoDto>(`${this.base}productos`, dto);
  }*/
}
