# Architecture Overview

## Solution Map

```
c:\Software\Fegus\
├── BackEnd\                        ← REST API (.NET 10)
│   ├── API\                        ← FastEndpoints, DI wiring
│   ├── Application\                ← CQRS handlers, use cases
│   ├── Domain\                     ← Entities, interfaces (no deps)
│   ├── Infrastructure\             ← Dapper + Npgsql, JWT, COPY writer
│   └── Common\                     ← Result<T>, CQRS base, pipeline behaviors
│
├── FegusDataAgent\                 ← Background Worker (.NET 10)
│   ├── FegusDAgent.Worker\         ← BackgroundService, DI wiring, Program.cs
│   ├── FegusDAgent.Application\    ← Use cases, logging interfaces
│   ├── FegusDAgent.Domain\         ← Entities, interfaces, enums (no deps)
│   └── FegusDAgent.Infrastructure\ ← HTTP clients, DB sources, checkpoints
│
└── fegus\                          ← Angular 21 frontend
    └── src\app\
        ├── features\               ← Domain feature modules
        ├── core\                   ← Auth, interceptors, base services
        └── shared\                 ← GridZComponent, reusable UI
```

---

## BackEnd

### Layer Rules

```
API (FastEndpoints)
  ├── Application (Commands/Queries via MediatR)
  │     └── Domain (Entities, Interfaces — zero NuGet dependencies)
  └── Infrastructure (implements Domain/Application interfaces)
        └── Common (Result<T>, CQRS base interfaces, pipeline behaviors)
```

- `Domain`: zero NuGet dependencies
- `Application`: references only `Common` and `Domain`
- `Infrastructure`: implements interfaces from `Domain` and `Application`
- `API`: wires everything; endpoints never call repositories directly

### Key Patterns

**Result\<T\> Pattern** — All handlers return `Result<T>`. Never throw for control flow.

```csharp
Result<T>.Success(value)
Result<T>.Failure(error, ErrorType.Technical | Validation | Unauthorized | NotFound | ConflictingData)
```

**CQRS via MediatR**

```csharp
public interface IQuery<TResponse> : IRequest<Result<TResponse>>;
public interface IQueryHandler<TRequest, TResponse> : IRequestHandler<TRequest, Result<TResponse>>;

public interface ICommand<TResponse> : IRequest<Result<TResponse>>;
public interface ICommandHandler<TRequest, TResponse> : IRequestHandler<TRequest, Result<TResponse>>;
```

**FastEndpoints** — extend `Endpoint<TRequest, TResponse>` or `EndpointWithoutRequest<TResponse>`:
- `Configure()` declares route, verb, auth policy
- `HandleAsync(req, ct)` sends MediatR message and maps result to HTTP response

**Database Access** — Dapper + Npgsql only (no EF). All queries call PostgreSQL stored functions:

```csharp
await conn.QueryAsync<T>("schema.function_name", new { param }, commandType: CommandType.StoredProcedure);
```

**Pipeline Behavior** — `ExceptionToResultBehavior` wraps every handler; converts unhandled exceptions to `Result.Failure` with `ErrorType.Technical`.

---

## BackEnd API Endpoints

### Authentication (`/auth`)

| Method | Route | Handler | Auth |
|--------|-------|---------|------|
| POST | `/auth/login` | GetLoginUserQueryHandler | Anonymous |
| POST | `/auth/logout` | GetLogoutQueryHandler | AuthenticatedUser |
| POST | `/auth/refresh` | GetRefreshTokenQueryHandler | Anonymous |

### Credit Data (`/crediticio`)

| Method | Route | Handler | Auth |
|--------|-------|---------|------|
| GET | `/crediticio/deudores/{idCliente}` | GetDeudoresQueryHandler | AuthenticatedUser |
| GET | `/crediticio/deudores/{idCliente}/{idDeudor}` | GetDeudorByIdQueryHandler | AuthenticatedUser |
| GET | `/crediticio/deudores/saludo` | GetSaludoDeudorQueryHandler | Anonymous |

### Configuration (`/fegusconfig`)

| Method | Route | Handler | Auth |
|--------|-------|---------|------|
| GET | `/fegusconfig/box/{idCliente}` | GetBoxDataLoadQueryHandler | AuthenticatedUser |
| GET | `/fegusconfig/box/{idCliente}/next` | GetNextBoxDataLoadQueryHandler | AuthenticatedUser |
| POST | `/fegusconfig/box` | CreateBoxDataLoadCommandHandler | AuthenticatedUser |
| PUT | `/fegusconfig/box` | UpdateBoxDataLoadCommandHandler | AuthenticatedUser |
| DELETE | `/fegusconfig/box/{idCliente}/{idLoad}` | DeleteBoxDataLoadCommandHandler | AuthenticatedUser |

### Ingestion (`/ingestion`)

Requires JWT with `idcliente` claim and `ingestion.agent` role (policy: `Ingestion`).

| Method | Route | Handler | Auth |
|--------|-------|---------|------|
| POST | `/ingestion/sessions` | CreateIngestionSessionCommandHandler | Ingestion |
| POST | `/ingestion/sessions/{sessionId}/stream` | ReceiveIngestionStreamCommandHandler | Ingestion |
| POST | `/ingestion/sessions/{sessionId}/commit` | CommitIngestionSessionCommandHandler | Ingestion |
| GET | `/ingestion/sessions/{sessionId:guid}` | GetIngestionSessionStatusQueryHandler | Ingestion |

**Session lifecycle:** `CREATED → RECEIVING → COMPLETED | FAILED`

**Stream endpoint** receives raw gzip-compressed NDJSON body. Backend uses `NdjsonStreamReader` to parse lines and `PostgresCopyStreamWriter` to bulk-insert into `fegusconfig.fe_ingestion_deudores_raw` via PostgreSQL binary COPY.

---

## Database Architecture

### Schemas

| Schema | Purpose |
|--------|---------|
| `fegusseg` | Users, roles, permissions, refresh tokens |
| `fegusdata` | Credit data: deudores, operaciones_credito |
| `fegusconfig` | Box data loads, ingestion sessions, raw ingestion data |
| `feguscatalogos` | SUGEF regulatory catalogs |
| `feguslocal` | Local staging for FegusDAgent (per-agent PostgreSQL instance) |

### Key Tables

- `fegusseg.users` — username, pass_hash (bcrypt), status, is_active
- `fegusseg.roles` / `fegusseg.user_roles` / `fegusseg.role_permissions` / `fegusseg.permissions`
- `fegusseg.fe_refresh_tokens` — token, TTL, is_revoked
- `fegusconfig.fe_box_data_load` — StateCode: `NEW | CREATED | VALIDATING | CALCULATING | COMPLETED | ERROR | CANCELLED`
- `fegusconfig.fe_ingestion_sessions` — session_id (UUID), session_state_code, last_sequence, dataset
- `fegusconfig.fe_ingestion_deudores_raw` — session_id, id_cliente, seq (bigint), payload (JSONB)
- `feguslocal.fe_box_data_load_local` — local copy of box with IdLoadLocal
- `feguslocal.deudores_staging` — local deudor staging

---

## FegusDAgent Architecture

### Layer Rules

```
FegusDAgent.Domain          ← No dependencies; entities, interfaces, enums
FegusDAgent.Application     ← Depends on Domain; orchestrates use cases
FegusDAgent.Infrastructure  ← Depends on Application + Domain; HTTP clients, DB sources
FegusDAgent.Worker          ← DI wiring + BackgroundService host
```

### Worker Concurrency

`Worker.cs` implements `BackgroundService` with a bounded `System.Threading.Channels` producer-consumer queue:
- **Producer**: enqueues `DataLoadJob` items on a timer (`PollIntervalSeconds`)
- **Consumers**: `ConsumerCount` concurrent tasks process jobs

Configuration section: `SaludoWorker`

```json
{
  "SaludoWorker": {
    "ConsumerCount": 3,
    "ParallelJobsPerTick": 2,
    "PollIntervalSeconds": 30,
    "ChannelCapacity": 100
  }
}
```

### Orchestration Flow (`DataLoadOrchestrationUseCase`)

```
1. GetNextBoxDataLoadUseCase       → GET /fegusconfig/box/{idCliente}/next
2. AuthenticateUseCase             → POST /auth/login (token cached 55 min)
3. [If StateCode=NEW]
   CreateBoxDataLoadLocalUseCase   → INSERT feguslocal.fe_box_data_load_local
   UpdateFeBoxDataLoadUseCase      → PUT /fegusconfig/box (StateCode → CREATED)
4. SendDeudoresUseCase             → stream Deudor entities
   [SendOperacionCreditoUseCase]   → stream OperacionCredito (currently disabled)
```

### Streaming Pipeline

```
IEntitySource<T>.GetDataStreamAsync()   → IAsyncEnumerable<T> from PostgreSQL stored function
HttpIngestionStreamSender               → ProducerStream (System.IO.Pipelines)
                                          + GZip (CompressionLevel.Fastest)
                                          + NDJSON serialization
                                          POST /ingestion/sessions/{sessionId}/stream
ICheckpointStore (FileCheckpointStore)  → .chk files per sessionId for resume support
```

### HTTP Clients

| Class | Interface | Purpose |
|-------|-----------|---------|
| `FegusApiTokenProvider` | `IFegusAuthClient` | Singleton; caches + refreshes JWT |
| `HttpFegusConfigClient` | `IFegusConfigClient` | Box data load CRUD |
| `HttpIngestionSessionClient` | `IIngestionSessionClient` | Session lifecycle |
| `HttpIngestionStreamSender` | `IIngestionStreamSender` | Gzip NDJSON stream upload |
| `HttpSaludoDeudorClient` | `ISaludoDeudorClient` | Demo/health check |

---

## Frontend Architecture

### Framework & Libraries

| Library | Version | Role |
|---------|---------|------|
| Angular | 21 | Framework (standalone components) |
| CoreUI | 5.6 | Admin layout template |
| AG Grid | 35.1 | Data grid |
| @auth0/angular-jwt | latest | JWT handling |
| RxJS | 7.8 | Reactive streams |

### Feature Structure

```
src/app/
├── core/
│   ├── auth/          ← AuthLocalService, LoginRequest/Response models
│   ├── interceptors/  ← AuthInterceptor (adds Authorization header)
│   └── services/      ← BaseApiService, ToastService
├── features/
│   ├── crediticio/
│   │   └── deudores/
│   │       ├── gestion-datos/   ← GestionDatosComponent, DeudorApiService
│   │       └── models/          ← DeudorDto, DeudorValue<T>
│   └── fegusconfig/
│       └── boxdataload/
│           ├── mant-boxdataload/  ← MantBoxdataloadComponent, BoxDataLoadApiService
│           └── models/            ← BoxDataLoadDto, BoxDataLoadValue<T>
└── shared/
    ├── grid-z/        ← GridZComponent (AG Grid wrapper, metadata-driven)
    └── catalogs/      ← sugef-catalogs.ts (dropdown/tooltip mappings)
```

### Routes

| Path | Component | Auth |
|------|-----------|------|
| `/login` | LoginComponent | Anonymous |
| `/register` | RegisterComponent | Anonymous |
| `/crediticio/deudores/gestion-datos` | GestionDatosComponent | Authenticated |
| `/fegusconfig/boxdataload/mant-boxdataload` | MantBoxdataloadComponent | Authenticated |
| `/dashboard` | DashboardComponent | Authenticated |

### API Response Model

```typescript
export interface ApiResponse<T> {
  value: T;
  isSuccess: boolean;
  isFailure: boolean;
  error: string | null;
  errorType: string | null;
}
```

### GridZComponent

Reusable AG Grid wrapper with metadata-driven columns:

```typescript
@Input() columns: GridColumnConfig[];    // column definitions
@Input() rowData: any[];
@Input() selectionMode: 'single' | 'multiple';
@Input() pagination: boolean;
@Input() pageSize: number;
@Output() rowSelected: EventEmitter<any>;
@Output() rowDoubleClicked: EventEmitter<any>;
```

`GridColumnConfig.catalog` key maps to SUGEF catalog entries for automatic dropdown editors and tooltips.
