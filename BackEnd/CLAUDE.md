# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> See also `../CLAUDE.md` for the full multi-solution overview (Angular frontend, BackEnd, FegusDataAgent).

## Commands

```bash
# From c:/Software/Fegus/BackEnd/
dotnet build
dotnet run --project API       # listens on http://localhost:8080 by default
```

No test projects exist in this solution.

## Architecture

Clean Architecture with CQRS via MediatR, five projects:

```
API (FastEndpoints)
  └─ Application (Commands / Queries via MediatR)
       └─ Domain (Entities, Interfaces — no dependencies)
  └─ Infrastructure (Dapper + Npgsql → PostgreSQL)
  └─ Common (Result pattern, base CQRS interfaces, pipeline behaviors)
```

**Layer rules:**
- `Domain` has zero NuGet dependencies.
- `Application` references only `Common` and `Domain`.
- `Infrastructure` implements interfaces declared in `Domain/Interfaces/` and `Application/Interfaces/`.
- `API` wires everything together; endpoints never call repositories directly.

## Adding a New Feature

1. Domain entity → `Domain/Entities/`
2. Repository interface → `Domain/Interfaces/` or `Application/Interfaces/`
3. Command or Query record → `Application/Feactures/<Feature>/` implementing `ICommand<T>` / `IQuery<T>` from `Common`
4. Handler implementing `ICommandHandler<,>` / `IQueryHandler<,>` in the same folder
5. Repository implementation in `Infrastructure/Persistence/` using Dapper
6. FastEndpoints endpoint in `API/Endpoints/<Feature>/`
7. Register repository in `Infrastructure/DependencyInjection.cs`

The folder is spelled `Feactures` (not `Features`) — intentional and consistent across the solution.

## Key Patterns

**Result pattern** — all handlers return `Result<T>` or `Result` (`Common/Share/`). Never throw for control flow.
- `Result<T>.Success(value)`
- `Result.Failure(error, ErrorType.X)` — ErrorType maps to HTTP status:
  - `Validation` → 400, `Unauthorized` → 401, `NotFound` → 404, `ConflictingData` → 409, `Technical` → 500

**FastEndpoints** — endpoints extend `Endpoint<TRequest, TResponse>` or `EndpointWithoutRequest`:
- `Configure()` declares route, verb, auth policy, roles.
- `HandleAsync(req, ct)` sends the MediatR command/query and maps the result via `Send.ResponseAsync(result)`.

**Database** — Dapper + Npgsql only (no EF). All queries call PostgreSQL stored functions:
```csharp
await conn.QueryAsync<T>("schema.function_name", new { param }, commandType: CommandType.StoredProcedure);
```
Active schemas: `fegusconfig` (system/config tables), `fegusdata` (debtor data), `feguscatalogos` (catalogs), `feguslocal` (processing).

Dapper column mapping: stored functions return snake_case columns; use `AS "CamelCaseName"` aliases in SQL or explicit mapping — Dapper does not auto-map by default.

**MediatR pipeline behaviors** (`Common/Behavior/`):
- `ExceptionToResultBehavior` — wraps every handler, logs with `ErrorId` + `TraceId`, converts unhandled exceptions to `Result.Failure(message, Technical)` without stack trace exposure.

**Logging** — Serilog with file (daily rolling, 15-day retention) + console sinks. Configured in `appsettings.json`. `ExceptionLoggingMiddleware` (API layer) catches unhandled exceptions outside the MediatR pipeline.

**Middleware order** — `ExceptionLoggingMiddleware → CORS → Auth → Authorization → FastEndpoints`

## Implemented Feature Domains

| Domain | Routes prefix | Feactures folder |
|--------|--------------|-----------------|
| Auth | `/auth` | `Auth/Login/Queries/` |
| Deudores | `/crediticio/deudores` | `Deudores/Queries/` |
| FegusConfig (BoxDataLoad) | `/fegusconfig/box` | `FegusConfig/` |
| Ingestion | `/ingestion/sessions` | `Ingestion/` |

## Ingestion API

Session lifecycle: `Created → Receiving → Completed | Failed` (tracked in `fegusconfig.fe_ingestion_sessions`).

Routes require JWT with `idcliente` claim and `ingestion.agent` role (policy: `Ingestion`):
- `POST /ingestion/sessions` — create session (`{ IdLoad, Dataset }` — Dataset is `DataSetNameIngestion`: Deudores | OperacionesCredito | GarantiasOperacion)
- `GET  /ingestion/sessions/{sessionId}` — poll session status
- `GET  /ingestion/sessions/inflight` — get active session for a client
- `POST /ingestion/sessions/{sessionId}/stream` — upload raw gzip-compressed NDJSON body (not multipart; Kestrel limit: 500 MB)
- `POST /ingestion/sessions/{sessionId}/commit` — finalize; triggers PostgreSQL binary COPY bulk insert via `PostgresCopyStreamWriter`

`PostgresCopyStreamWriter` decompresses gzip on-the-fly, parses NDJSON line-by-line via `NdjsonStreamReader`, and routes rows into the correct staging table by `DataSetNameIngestion`.

`IngestionSessionReaperHostedService` runs every 60 min and marks sessions older than 6 h as `Failed` to prevent orphans. Configured via `IngestionReaper:OrphanSessionTimeoutHours` and `IngestionReaper:CheckIntervalMinutes`.

Temp files land in `IngestionStorage:TempStoragePath` (Windows: `C:\Fegus\TempStorage`; Linux/prod: `/var/fegus/ingestion-temp`).

## Authentication

JWT Bearer. Token claims: `sub` (userId), `idcliente`, `username`, `email`, `roles`, `perms`.
Refresh tokens: 7-day expiry, stored in `fe_refresh_tokens` table.
Auth policies: `AuthenticatedUser` (valid JWT) and `Ingestion` (requires `ingestion.agent` role).
`JwtTokenService` and `IAuthRepository` live in `Infrastructure`.

## Configuration

| Key | Dev value |
|-----|-----------|
| `ConnectionStrings:Postgres` | `Host=localhost;Port=5433;Database=FegusApp;...` |
| `Jwt:AccessTokenMinutes` | `15` |
| `IngestionStorage:TempStoragePath` | `C:\Fegus\TempStorage` |
| `IngestionReaper:OrphanSessionTimeoutHours` | `6` |

## Database Reference

The folder `BackEnd/DataBase/Schemas/` contains the authoritative SQL scripts for every database object in the BackEnd database. **Always read the relevant files here before writing or modifying any query, stored function call, or schema-dependent code.**

```
DataBase/Schemas/
  feguscatalogos/Tables/     ← SUGEF catalog tables (tipos, sectores, etc.)
  fegusconfig/Tables/        ← Ingestion sessions, box loads, state machine tables
  fegusconfig/Functions/     ← fn_box_data_load_*, fn_next_box_data_load_get
  fegusconfig/Sequences/     ← Sequences for ingestion raw tables and box loads
  fegusdata/Tables/          ← deudores, operacionescredito (processed data)
  fegusseg/Tables/           ← users, roles, permissions, refresh_tokens, customers
  fegusseg/Sequences/        ← Sequences for security entities
  fegusseg/Procedures/       ← sp_generate_test_security_data
```

Use these scripts to:
- Confirm exact column names and types before writing Dapper queries or `AS "CamelCaseName"` aliases.
- Check function signatures (parameters, return types) before calling stored functions.
- Understand table relationships and constraints before adding new features.
- Keep scripts up to date whenever a schema change is deployed.

## Cross-Cutting Notes

- Business logic names are in **Spanish** (deudores, garantías, clase crediticio, etc.) — match this convention.
- PostgreSQL function calls use Spanish snake_case names (e.g., `fegusdata.obtener_deudores_lista`).
- Every DB call and JWT claim is scoped by `id_cliente` — never query without this filter.
