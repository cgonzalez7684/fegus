import { inject, Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';

export abstract class BaseApiService {
  protected http = inject(HttpClient);
  protected baseUrl = environment.baseUrl;

  protected get<T>(url: string) {
    return this.http.get<T>(`${this.baseUrl}/${url}`);
  }

  protected post<T>(url: string, body: any) {
    return this.http.post<T>(`${this.baseUrl}/${url}`, body);
  }
}
