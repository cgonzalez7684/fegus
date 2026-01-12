import { Injectable } from '@angular/core';
import { MsalService } from '@azure/msal-angular';

@Injectable({ providedIn: 'root' })
export class AuthService {

  constructor(private msal: MsalService) {}

  login(): void {
    //this.msal.loginRedirect();
    this.msal.loginRedirect({
      prompt: 'login',
      scopes: []
    });
  }

  logout(): void {
    this.msal.logoutRedirect();
  }

  setActiveAccount(): void {
    const accounts = this.msal.instance.getAllAccounts();
    if (accounts.length > 0) {
      this.msal.instance.setActiveAccount(accounts[0]);
    }
  }

  isAuthenticated(): boolean {
    return this.msal.instance.getActiveAccount() !== null;
  }

  getUser(): any {
    return this.msal.instance.getActiveAccount();
  }
}
