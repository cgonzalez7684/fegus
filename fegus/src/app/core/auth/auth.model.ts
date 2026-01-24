

export interface LoginRequest {
  idCliente: number;
  email: string;
  password: string;
}

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
}

export interface ApiResult<T> {
  value: T;
  isSuccess: boolean;
  isFailure: boolean;
  error: string | null;
  errorType: string | null;
}