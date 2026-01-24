import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthLocalService } from './authlocal.service';

export const authGuard: CanActivateFn = () => {
  const auth = inject(AuthLocalService);
  const router = inject(Router);

  if (auth.isAuthenticated()) {
    return true;
  }

  router.navigate(['/login']);
  return false;
};
