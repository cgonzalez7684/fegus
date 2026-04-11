# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Layout

Three independent deployable units share this monorepo:

```
BackEnd/          .NET 10 REST API (FastEndpoints + MediatR + Dapper)
FegusDataAgent/   .NET 10 Background Worker (streams data from local DB to BackEnd)
fegus/            Angular 21 frontend (CoreUI admin template + AG Grid)
docs/             Architecture and convention documentation — always read before making changes
```

Each project has its own `CLAUDE.md` with per-project detail. This file covers cross-project concerns.

## Build & Run Commands

### BackEnd
```bash
cd BackEnd
dotnet build
dotnet run --project API           # API listens on http://localhost:8080
dotnet test
```

### FegusDAgent
```bash
cd FegusDataAgent
dotnet build
dotnet run --project FegusDAgent.Worker
dotnet publish -c Release --project FegusDAgent.Worker
```
No test projects exist in this solution.

### Frontend
```bash
cd fegus
npm install
npm start          # dev server at http://localhost:4200 with hot reload
npm run build      # production build → dist/fegus-app/browser/
```

### CI/CD
- Pushes to `main` touching `BackEnd/**` deploy to Azure App Service (`Appfeguscgr`) via `.github/workflows/BackEndF.yml`
- Pushes to `main` touching `fegus/**` deploy to Azure Static Web Apps via `.github/workflows/FrontEndF.yml`
- FegusDAgent has no CI pipeline; publish manually

## Architecture Documentation

Before making non-trivial changes, read the relevant docs:

| File | When to read |
|------|-------------|
| [docs/FEGUS_MASTER_CONTEXT.md](docs/FEGUS_MASTER_CONTEXT.md) | First time or cross-project changes |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Endpoints, DB schemas, layer rules, data flow |
| [docs/CONVENTIONS.md](docs/CONVENTIONS.md) | Naming, folder structure, patterns |
| [docs/DOMAINS.md](docs/DOMAINS.md) | Business domain status and entity locations |
| [docs/CURRENT_STATUS.md](docs/CURRENT_STATUS.md) | What is implemented, in-progress, and known issues |

## Cross-Project Architecture

### How the Three Systems Connect

```
Frontend (Angular)
    │  JWT Bearer auth
    ▼
BackEnd (REST API)                    ← source of truth
    ▲
    │  GET /fegusconfig/box/{idCliente}/next
    │  POST /ingestion/sessions
    │  POST /ingestion/sessions/{id}/stream   (gzip NDJSON body)
    │  POST /ingestion/sessions/{id}/commit
    │
FegusDAgent (Worker)                  ← calls BackEnd, not the other way around
    │  reads from local PostgreSQL (feguslocal schema)
    │  streams Deudor/OperacionCredito entities
    └─ writes checkpoints to local .chk files
```

FegusDAgent has its **own local PostgreSQL instance** (schema `feguslocal`) separate from the BackEnd database. The agent reads financial data from `feguslocal` and streams it to the BackEnd's ingestion API.

### Multi-Tenancy

Every DB table, API endpoint, and JWT claim is scoped by `id_cliente`. The BackEnd extracts it from the JWT claim `idcliente`. Never perform DB operations without filtering by `id_cliente`.

### Result\<T\> Pattern (BackEnd)

All MediatR handlers return `Result<T>`. Never throw for control flow.

```csharp
return Result<T>.Success(value);
return Result<T>.Failure("reason", ErrorType.NotFound);  // 404
// ErrorType: Validation→400, Unauthorized→401, NotFound→404, ConflictingData→409, Technical→500
```

### Database Access (BackEnd + FegusDAgent)

Dapper + Npgsql only — no Entity Framework anywhere. All queries call PostgreSQL stored functions:
```csharp
await conn.QueryAsync<T>("schema.fn_name", new { param }, commandType: CommandType.StoredProcedure);
```
PostgreSQL function names use Spanish snake_case (`feguslocal.obtener_deudores_lista`).

### Ingestion Session Lifecycle

`CREATED → RECEIVING → COMPLETED | FAILED` (tracked in `fegusconfig.fe_ingestion_sessions`)

The stream endpoint receives a raw gzip-compressed NDJSON body and bulk-inserts rows into `fegusconfig.fe_ingestion_deudores_raw` via PostgreSQL binary COPY (`PostgresCopyStreamWriter`). Each row carries a sequence number used by `FileCheckpointStore` on the agent side for resume-on-failure.

## Key Non-Obvious Conventions

- The application features folder is spelled **`Feactures`** (not `Features`) in `BackEnd/Application/Feactures/` — this is intentional and consistent
- The worker's appsettings section is named **`SaludoWorker`** even though it controls the general worker pool (`ConsumerCount`, `PollIntervalSeconds`, etc.)
- Business entity and DB identifier names are in **Spanish**; C# class/method names and API routes are in **English**
- `OperacionCredito` streaming is implemented but currently **disabled** in `FegusDataAgent/FegusDAgent.Application/UseCases/DataLoadOrchestrationUseCase.cs` (line ~96, commented out in the `Task.WhenAll` call)
- The frontend uses `GridZComponent` as the single AG Grid wrapper for all data grids — do not embed AG Grid directly in feature components
- SUGEF catalog mappings live in `fegus/src/app/shared/catalogs/sugef-catalogs.ts` and drive dropdown editors and tooltips via `GridColumnConfig.catalog`
