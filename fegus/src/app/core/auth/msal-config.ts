import { Configuration } from '@azure/msal-browser';
//import { environment } from 'src/environments/environment';
import { environment } from '../../../environments/environment';

export const msalConfig: Configuration = {
  auth: {
      clientId: environment.AuthClientId,
      authority: environment.AuthAuthority,
      redirectUri: 'http://localhost:4200' //environment.AuthRedirectUri
    },
    cache: {
      cacheLocation: 'localStorage',
      storeAuthStateInCookie: false
    }
};
