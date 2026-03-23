import { Injectable } from "@angular/core";
import { BaseApiService } from "../../../../core/http/base-api.service";
import { Observable } from "rxjs";
import { ApiResponse } from "../../../../core/dtos/api-response.dto";
import { BoxDataLoadDto } from "../models/BoxDataLoad.dto"; 
import { BoxDataLoadValue } from "../models/BoxDataLoadValue.dto";

@Injectable({ providedIn: 'root' })
export class BoxDataLoadApiService extends BaseApiService {

    GetBoxDataLoad(idCliente: string, idLoad? : string): Observable<ApiResponse<BoxDataLoadDto[]>> {
        
        const endpoint = idLoad
        ? `fegusconfig/box/${idCliente}/${idLoad}`
        : `fegusconfig/box/${idCliente}`;

        //console.log('Endpoint construido:', endpoint);

        return this.get<ApiResponse<BoxDataLoadDto[]>>(endpoint);
    }

    postCreateBoxDataLoad(command: {
        idCliente: number;
        stateCode: string;
        isActive: string;
        asofDate?: string | null;
    }): Observable<ApiResponse<number | null>> {
        const endpoint = `fegusconfig/box`;
        return this.post<ApiResponse<number | null>>(endpoint, command);
    }

}