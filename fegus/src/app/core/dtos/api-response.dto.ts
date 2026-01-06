import { DeudorValue } from "./DeudorValue.dto";

export interface ApiResponse<T> {
  value: DeudorValue<T>;
  isSuccess: boolean;
  isFailure: boolean;
  error: string | null;
  errorType: string | null;
}
