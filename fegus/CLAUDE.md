# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# From c:/Software/Fegus/fegus/
npm install
npm start          # dev server at http://localhost:4200 with hot reload
npm run build      # production build → dist/fegus-app/browser/
```

There are no configured lint or test runner scripts. Spec files exist (`.spec.ts`) but are not actively maintained.

## App Structure

```
src/app/
  core/           ← Auth, HTTP base, shared DTOs — no business logic here
    auth/         ← AuthLocalService, AuthInterceptor, AuthGuard, auth.model.ts
    http/         ← BaseApiService (abstract, all feature services extend this)
    dtos/         ← ApiResponse<T> (mirrors backend Result<T>)
  feactures/      ← All Fegus business features (intentional spelling, matches backend)
    clase-crediticio/deudores/   ← Deudor management
    fegusconfig/boxdataload/     ← Box data load management
  shared/
    components/grid-z/   ← GridZComponent — the ONLY AG Grid wrapper in the app
    models/              ← GridColumnConfig interface
    catalogs/            ← SUGEF_CATALOGS (SUGEF code→description mappings)
  services/       ← App-wide services (ToastService)
  views/          ← CoreUI template boilerplate — do NOT put business features here
  layout/         ← Default shell layout (header, footer, sidebar)
```

## Feature Folder Convention

Every business feature under `feactures/` follows this pattern:

```
feactures/<domain>/<feature>/
  models/
    XxxDto.ts              ← API response shape
    XxxValue.dto.ts        ← Wrapper value type (when API wraps result)
    xxx.grid.config.ts     ← GridColumnConfig[] export (column definitions)
  pages/
    <page-name>/
      <page>.component.ts  ← Standalone component, lazy-loaded
  services/
    xxx-api.services.ts    ← Extends BaseApiService
  xxx.routes.ts            ← Lazy route definitions with AuthGuard
```

## Adding a New Feature

1. Create the folder tree above under `feactures/<domain>/<feature>/`
2. Define `XxxDto` and a service extending `BaseApiService`:
   ```ts
   @Injectable({ providedIn: 'root' })
   export class XxxApiService extends BaseApiService {
     getData(idCliente: string) {
       return this.get<ApiResponse<XxxDto[]>>(`schema/endpoint/${idCliente}`);
     }
   }
   ```
3. Define a `GridColumnConfig[]` constant in `models/xxx.grid.config.ts`
4. Create a standalone page component using `GridZComponent` (never embed AG Grid directly)
5. Add lazy routes in `xxx.routes.ts` protected by `canActivate: [AuthGuard]`
6. Register the route in the app's main router

## Key Patterns

### GridZComponent

The single AG Grid wrapper. Always use it instead of `AgGridAngular` directly:

```html
<app-grid-z
  [columns]="columns"
  [rowData]="rowData"
  [selectionMode]="'single'"
  (rowDoubleClicked)="openModal($event)"
  (cellValueChanged)="onCellChanged($event)">
</app-grid-z>
```

Columns with `catalog: 'TIPO_PERSONA'` automatically get:
- A tooltip showing the description
- A dropdown cell editor with `code - description` format
- A `valueParser` that converts the selection back to the raw numeric code

### ApiResponse\<T\>

All API calls return this shape (mirroring the backend `Result<T>`):
```ts
interface ApiResponse<T> {
  value: T | null;
  isSuccess: boolean;
  isFailure: boolean;
  error: string | null;
  errorType: string | null;
}
```
Always check `response.isSuccess` before using `response.value`.

### Auth

- `AuthLocalService` stores tokens in `localStorage` (`fegus_access_token`, `fegus_refresh_token`)
- `AuthInterceptor` attaches the Bearer token to every HTTP request and auto-refreshes on 401
- `AuthGuard` validates token existence and expiry (via `@auth0/angular-jwt`) on route activation
- Login payload requires `{ idCliente: number, username, password }`

### ToastService

Signal-based. Use `inject(ToastService)` or constructor injection; call `.success(msg)` / `.error(msg)`:
```ts
private toastService = inject(ToastService);
this.toastService.success('Carga creada correctamente.');
this.toastService.error('No se pudo crear la carga.');
```

## Key Non-Obvious Conventions

- Business features live in `feactures/` (same intentional misspelling as the backend `Application/Feactures/`)
- `views/` is CoreUI template scaffolding — it is not used for business features
- All feature components are **standalone** (no NgModules)
- `BaseApiService` reads `environment.baseUrl` — change it in `src/environments/environment.ts` for local dev
- SUGEF catalog keys are added to `SUGEF_CATALOGS` in `shared/catalogs/sugef-catalogs.ts`; the `catalog` field on `GridColumnConfig` must match a key of that object (TypeScript-enforced)
