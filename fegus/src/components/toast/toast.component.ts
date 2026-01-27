import { Component, Input, signal } from '@angular/core';
import {
  ButtonDirective,
  ProgressComponent,
  ToastBodyComponent,
  ToastComponent,
  ToasterComponent,
  ToastHeaderComponent
} from '@coreui/angular';
import { ToastSampleIconComponent } from '../../components/toast/toast-sample-icon';

@Component({
  selector: 'app-toast',
  templateUrl: './toast.component.html',
  standalone: true,
  imports: [
    ButtonDirective,
    ProgressComponent,
    ToasterComponent,
    ToastComponent,
    ToastHeaderComponent,
    ToastSampleIconComponent,
    ToastBodyComponent
  ]
})
export class Toast02Component   {
  
  position = 'top-end';
  visible = signal(false);
  percentage = signal(0);

  toggleToast() {
    this.visible.update((value) => !value);
  }

  onVisibleChange($event: boolean) {
    this.visible.set($event);
    this.percentage.set(this.visible() ? this.percentage() : 0);
  }

  onTimerChange($event: number) {
    this.percentage.set($event * 25);
  }
 
}