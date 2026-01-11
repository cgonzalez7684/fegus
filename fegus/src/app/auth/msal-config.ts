import { Configuration } from '@azure/msal-browser';
import { environment } from 'src/environments/environment';

export const msalConfig: Configuration = {
  auth: {
      clientId: environment.AuthClientId,
      authority: environment.AuthAuthority,
      redirectUri: '/'
    },
    cache: {
      cacheLocation: 'localStorage',
      storeAuthStateInCookie: false
    }
};
