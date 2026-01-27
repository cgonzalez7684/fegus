import { Injectable, signal } from '@angular/core';

export interface AppToast {
  title?: string;
  message: string;
  color?: 'primary' | 'success' | 'danger' | 'warning' | 'info';
  delay?: number;
}

@Injectable({
  providedIn: 'root'
})
export class ToastService {

  // 🔥 Core del sistema
  toasts = signal<AppToast[]>([]);

  show(toast: AppToast) {
    this.toasts.update(list => [...list, toast]);

    // auto-remove
    if (toast.delay) {
      setTimeout(() => this.remove(toast), toast.delay);
    }
  }

  error(message: string) {
    this.show({
      title: 'Error',
      message,
      color: 'danger',
      delay: 4000
    });
  }

  success(message: string) {
    this.show({
      title: 'Éxito',
      message,
      color: 'success',
      delay: 3000
    });
  }

  remove(toast: AppToast) {
    this.toasts.update(list => list.filter(t => t !== toast));
  }
}
