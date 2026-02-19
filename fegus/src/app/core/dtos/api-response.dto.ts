

export interface ApiResponse<T> {
  //value: DeudorValue<T>;
  value: T | null;
  isSuccess: boolean;
  isFailure: boolean;
  error: string | null;
  errorType: string | null;
}
