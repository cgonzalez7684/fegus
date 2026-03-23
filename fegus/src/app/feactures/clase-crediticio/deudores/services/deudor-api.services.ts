import { Injectable } from '@angular/core';
import { BaseApiService } from '../../../../core/http/base-api.service';
//import { BaseApiService } from '@core/http/base-api.service';
import { DeudorDto } from '../models/deudor.dto';
import { Observable } from 'rxjs';
import { ApiResponse } from '../../../../core/dtos/api-response.dto';
import { DeudorValue } from '../models/DeudorValue.dto';

@Injectable({ providedIn: 'root' })
export class DeudorApiService extends BaseApiService {
 

  getDeudor(idCliente: string, idDeudor: string): Observable<ApiResponse<DeudorValue<DeudorDto>>> {
    const endpoint = `crediticio/deudores/${idCliente}/${idDeudor}`;
    return this.get<ApiResponse<DeudorValue<DeudorDto>>>(endpoint);
  }

  getDeudores(idCliente: string): Observable<ApiResponse<DeudorValue<DeudorDto[]>>> {
    const endpoint = `crediticio/deudores/${idCliente}`;

    console.log('Endpoint getDeudores construido:', endpoint);

    return this.get<ApiResponse<DeudorValue<DeudorDto[]>>>(endpoint);
  }

  getSaludo(): Observable<{ mensaje: string }> {
    return this.get<{ mensaje: string }>('crediticio/deudores/saludo');
  }
}
