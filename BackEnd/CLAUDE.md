# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

> See also `../fegus/CLAUDE.md` for the full multi-solution overview (Angular frontend, BackEnd, FegusDataAgent).

## Commands

```bash
# From c:/Software/Fegus/BackEnd/
dotnet build
dotnet run --project API       # listens on http://localhost:8080 by default
dotnet test
```

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

Note: the folder is spelled `Feactures` (not `Features`) — this is intentional and consistent across the solution.

## Key Patterns

**Result pattern** — all handlers return `Result<T>` or `Result` (`Common/Share/`). Never throw for control flow.
- Success: `Result<T>.Success(value)`
- Failure: `Result.Failure(error, ErrorType.Technical | Validation | Unauthorized)`
- Endpoints map `ErrorType` to HTTP status codes.

**FastEndpoints** — endpoints extend `Endpoint<TRequest, TResponse>`:
- `Configure()` declares route, verb, auth policy, roles.
- `HandleAsync(req, ct)` sends the MediatR command/query and maps the result.

**Database** — Dapper + Npgsql only (no EF). All queries call PostgreSQL stored functions:
```csharp
await conn.QueryAsync<T>("schema.function_name", new { param }, commandType: CommandType.StoredProcedure);
```
Schemas in use: `fegusconfig`, `feguslocal`, `public`.

**MediatR pipeline behaviors** (registered in `Common/Behavior/`):
- `ExceptionToResultBehavior` — wraps every handler, converts unhandled exceptions to `Result.Failure`.

## Ingestion API

Session lifecycle: `Created → Receiving → Completed | Failed` (tracked in `fegusconfig.fe_ingestion_sessions`).

Routes require JWT with `idcliente` claim and `ingestion.agent` role:
- `POST /ingestion/sessions` — create session (body: `{ IdLoad, Dataset }`)
- `GET  /ingestion/sessions/{sessionId}` — poll session status
- `POST /ingestion/sessions/{sessionId}/stream` — upload gzip NDJSON body (raw request body, not multipart)
- `POST /ingestion/sessions/{sessionId}/commit` — finalize; triggers PostgreSQL COPY bulk insert via `PostgresCopyStreamWriter`

Temp files land in `IngestionStorage:TempStoragePath` (configured per environment).

## Authentication

JWT Bearer. Token claims: `sub` (userId), `idcliente`, `username`, `email`, `roles`, `perms`.
Refresh tokens: 7-day expiry, stored in `fe_refresh_tokens` table.
`JwtTokenService` and `IAuthRepository` live in `Infrastructure`.

## Configuration

| Key | Dev value |
|-----|-----------|
| `ConnectionStrings:Postgres` | `Host=localhost;Port=5433;Database=FegusApp;...` |
| `Jwt:AccessTokenMinutes` | `15` |
| `IngestionStorage:TempStoragePath` | `C:\Fegus\TempStorage` |
| `Cors:AllowedOrigins` | `http://localhost:4200` |

## Cross-Cutting Notes

- Business logic names are in **Spanish** (deudores, garantías, clase crediticio, etc.) — match this convention.
- PostgreSQL function calls use Spanish names (e.g., `feguslocal.obtener_deudores_lista`).
