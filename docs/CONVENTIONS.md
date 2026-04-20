# Development Conventions

## General

- Business entity names and PostgreSQL identifiers use **Spanish** (`deudores`, `id_cliente`, `obtener_deudores_lista`)
- C# class/method/variable names and API routes use **English**
- All operations are scoped by `id_cliente` (multi-tenancy)
- Never throw for control flow — use `Result<T>` instead

---

## BackEnd (.NET)

### Layer Rules

- `Domain` has zero NuGet dependencies
- `Application` references only `Common` and `Domain`
- `Infrastructure` implements interfaces declared in `Domain` or `Application`
- `API` endpoints never call repositories directly; always go through MediatR

### Folder Naming

- Feature handlers live in `Application/Feactures/<Feature>/` — note the intentional spelling **Feactures** (not Features)
- Domain entities in `Domain/Entities/`
- Repository interfaces in `Domain/Interfaces/` or `Application/Interfaces/`
- Infrastructure implementations in `Infrastructure/Persistence/`
- Endpoints in `API/Endpoints/<Feature>/`

### Adding a New Feature

1. Domain entity → `Domain/Entities/`
2. Repository interface → `Domain/Interfaces/` or `Application/Interfaces/`
3. Command or Query record implementing `ICommand<T>` / `IQuery<T>` → `Application/Feactures/<Feature>/`
4. Handler implementing `ICommandHandler<,>` / `IQueryHandler<,>` in the same folder
5. Repository implementation in `Infrastructure/Persistence/` using Dapper
6. FastEndpoints endpoint in `API/Endpoints/<Feature>/`
7. Register repository in `Infrastructure/DependencyInjection.cs`

### Result Pattern

```csharp
// Success
return Result<long?>.Success(id);

// Failure
return Result<long?>.Failure("Record not found", ErrorType.NotFound);
```

Endpoints map `ErrorType` to HTTP status codes:
- `Validation` → 400
- `Unauthorized` → 401
- `NotFound` → 404
- `ConflictingData` → 409
- `Technical` → 500

### Database Access

- Use Dapper + Npgsql only (no Entity Framework)
- All queries call PostgreSQL stored functions:
  ```csharp
  await conn.QueryAsync<T>("schema.fn_name", new { param }, commandType: CommandType.StoredProcedure);
  ```
- Use `IDbConnectionFactory.CreateConnectionAsync(ct)` (async preferred over sync `CreateConnection()`)
- Database function names use snake_case and Spanish names

### Naming Conventions

| Artifact | Convention | Example |
|----------|-----------|---------|
| Entities | PascalCase, English | `IngestionSession`, `FeBoxDataLoad` |
| Commands | `<Verb><Noun>Command` | `CreateIngestionSessionCommand` |
| Queries | `Get<Noun>Query` | `GetDeudoresQuery` |
| Handlers | `<Command|Query>Handler` | `CreateIngestionSessionCommandHandler` |
| Endpoints | `<Verb><Noun>Endpoint` | `CreateIngestionSessionEndpoint` |
| Repositories | `I<Noun>Repository` / `<Noun>Repository` | `IBoxDataRepository` / `BoxDataRepository` |
| DB functions | `schema.fn_<verb>_<noun>` | `fegusconfig.fn_box_data_load_create` |

### Authentication Policies

| Policy | Requirement |
|--------|-----------|
| `AuthenticatedUser` | Any valid JWT |
| `Ingestion` | Valid JWT with role `ingestion.agent` |

---

## FegusDAgent (.NET Worker)

### Layer Rules

Same Clean Architecture as BackEnd:
- `Domain`: no dependencies — entities, interfaces, enums
- `Application`: orchestrates use cases, no infrastructure knowledge
- `Infrastructure`: implements interfaces, handles HTTP/DB
- `Worker`: DI wiring only, no business logic

### Dependency Injection Rules

- All services registered in `FegusDAgent.Worker/Program.cs`
- Use `Scoped` for application services (use cases, sources)
- Use `Singleton` only for stateless or explicitly thread-safe services (e.g., `FegusApiTokenProvider`)
- Never use `Singleton` for services with database access

### Adding a New Entity Stream

1. Add entity class → `FegusDAgent.Domain/Entities/`
2. Implement `IEntitySource<T>` → `FegusDAgent.Infrastructure/Persistence/` calling a PostgreSQL stored function
3. Add use case → `FegusDAgent.Application/UseCases/` following `SendDeudoresUseCase` pattern
4. Register source and use case in `FegusDAgent.Worker/Program.cs`
5. Wire into `DataLoadOrchestrationUseCase` if it should run in the main data load cycle

### Streaming Rules

- Never load entire datasets into memory — use `IAsyncEnumerable<T>`
- Each row must carry an incrementing sequence number for checkpoint support
- Always checkpoint after successful batch sends
- Gzip compress all outbound streams (`CompressionLevel.Fastest`)

### Use Case Naming

| Class | Pattern |
|-------|---------|
| `DataLoadOrchestrationUseCase` | Top-level orchestrator |
| `AuthenticateUseCase` | Single concern, returns token |
| `SendDeudoresUseCase` | Entity-specific streaming |
| `CreateBoxDataLoadLocalUseCase` | Local persistence action |

---

## Database

### Naming

- All identifiers: `snake_case`
- Schemas: `fegusseg`, `fegusdata`, `fegusconfig`, `feguscatalogos`, `feguslocal`
- Stored functions: `schema.fn_<verb>_<noun>_<qualifier>` or `schema.obtener_<noun>`
- Every table includes `id_cliente` as the multi-tenant partition key
- Audit columns: `created_at_utc`, `updated_at_utc`

### Patterns

- Use JSONB for flexible or evolving payloads (e.g., raw ingestion data)
- Use PostgreSQL binary COPY for bulk inserts (never row-by-row INSERT for large datasets)
- Store raw ingestion rows in staging tables before promotion to domain tables

---

## Frontend (Angular)

### File Structure

- Feature modules under `src/app/features/<domain>/<subdomain>/`
- Shared reusable components under `src/app/shared/`
- Core infrastructure (auth, interceptors, base services) under `src/app/core/`

### Component Rules

- Use standalone components (no NgModules)
- Prefer `GridZComponent` for all data grids — do not embed AG Grid directly in feature components
- Pass column definitions via `GridColumnConfig[]` metadata, not hard-coded AG Grid column defs

### Service Rules

- Extend `BaseApiService` for all API-calling services
- Use `AuthInterceptor` for JWT injection (do not add headers manually)
- Use `ApiResponse<T>` as the standard HTTP response wrapper

### State Management

- No centralized state store (e.g., NgRx); use component-local state and services
- Auth state persisted in `localStorage` via `AuthLocalService`

### SUGEF Catalogs

- Catalog keys in `sugef-catalogs.ts` map numeric codes to descriptions
- Always reference catalogs via the `catalog` field on `GridColumnConfig` — never hardcode label lists in components

---

## Git & CI/CD

- Branch naming: `feature/<name>`, `fix/<name>`, `release/<version>`
- Commits should be in Spanish or English consistently per team agreement
- CI runs on GitHub Actions; do not bypass hooks with `--no-verify`
- Never force-push to `main`
