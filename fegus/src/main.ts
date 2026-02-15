		/// <reference types="@angular/localize" />
import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app/app.component';
import { appConfig } from './app/app.config';

import { ModuleRegistry, ValidationModule} from 'ag-grid-community';
import { AllCommunityModule } from 'ag-grid-community';

ModuleRegistry.registerModules([AllCommunityModule]);

if(process.env['NODE_ENV'] !== 'production') {
    ModuleRegistry.registerModules([ValidationModule]);
}




bootstrapApplication(AppComponent, appConfig)
  .catch(err => console.error(err));