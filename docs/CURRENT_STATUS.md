# Current Project Status

_Last updated: 2026-04-10_

---

## Completed

### BackEnd
- Clean Architecture foundation (Domain, Application, Infrastructure, Common, API)
- JWT authentication: login, logout, refresh token (7-day TTL, revocation)
- Authorization policies: `AuthenticatedUser`, `Ingestion` (role `ingestion.agent`)
- CQRS via MediatR with `ExceptionToResultBehavior` pipeline
- `Result<T>` pattern across all handlers
- Deudores endpoints: `GET /crediticio/deudores/{idCliente}`, `GET /crediticio/deudores/{idCliente}/{idDeudor}`
- BoxDataLoad CRUD: `GET`, `POST`, `PUT`, `DELETE /fegusconfig/box`
- `GET /fegusconfig/box/{idCliente}/next` — next pending box for FegusDAgent
- Ingestion session lifecycle:
  - `POST /ingestion/sessions` — create session
  - `POST /ingestion/sessions/{sessionId}/stream` — receive gzip NDJSON stream
  - `POST /ingestion/sessions/{sessionId}/commit` — finalize session
  - `GET /ingestion/sessions/{sessionId}` — status query
- `PostgresCopyStreamWriter` — binary COPY bulk insert to `fegusconfig.fe_ingestion_deudores_raw`
- `NdjsonStreamReader` — async NDJSON line parsing
- PostgreSQL schemas: `fegusseg`, `fegusdata`, `fegusconfig`, `feguscatalogos`, `feguslocal`
- BCrypt password hashing
- Multi-tenant scoping via `id_cliente` claim

### FegusDAgent
- Clean Architecture worker service (.NET 10)
- `DataLoadOrchestrationUseCase` — full orchestration: poll → authenticate → local persist → update remote → stream
- `SendDeudoresUseCase` — streaming pipeline for Deudor entities
- `SendOperacionCreditoUseCase` — implemented but currently disabled in orchestrator
- `FegusApiTokenProvider` — singleton with 55-minute token cache + refresh
- `HttpIngestionSessionClient` — create, commit, status
- `HttpIngestionStreamSender` — ProducerStream + gzip + NDJSON via `System.IO.Pipelines`
- `FileCheckpointStore` — `.chk` file per sessionId for resume support
- `DeudoresSource` — `IEntitySource<Deudor>` backed by `feguslocal.obtener_deudores_lista`
- `OperacionCreditoSource` — `IEntitySource<OperacionCredito>` implemented
- Worker concurrency via `System.Threading.Channels` (bounded queue, configurable consumers)
- 20+ domain entities defined: Deudor, OperacionCredito, GarantiaMobiliaria, Fideicomiso, Codeudor, BienesRealizables, and others
- `DataLoadState` enum: `NEW`, `CREATED`, `STAGING`, `VALIDATING`, `CALCULATING`, `COMPLETED`, `ERROR`, `CANCELLED`
- EventLogger (NLog-based) with `IEventLogger<T>` interface
- `FegusLocalRepository` for local box data persistence

### Frontend
- Angular 21 standalone components with CoreUI 5.6 admin template
- JWT auth with localStorage persistence and `AuthInterceptor`
- `GridZComponent` — AG Grid 35 wrapper with metadata-driven columns and SUGEF catalog integration
- BoxDataLoad feature: list, create, update, delete via modal
- Deudores feature: list grid with row selection and detail view
- `BaseApiService` with `get<T>()` and `post<T>()` helpers
- `AuthLocalService` — login/logout/token management
- `ToastService` — success/error notifications
- SUGEF catalogs in `sugef-catalogs.ts` (dropdown editors, tooltips)
- Navigation menu wired for Administración, Integración de datos, Clase de datos Crédito, Clase de datos Garantías

---

## In Progress

| Item | Component | Notes |
|------|-----------|-------|
| OperacionCredito streaming | FegusDAgent | `SendOperacionCreditoUseCase` implemented; disabled in `DataLoadOrchestrationUseCase` (line ~97) — needs re-enable and testing |
| BoxDataLoad state transitions beyond `CREATED` | BackEnd + FegusDAgent | STAGING, VALIDATING, CALCULATING states not yet orchestrated |
| Validation Engine | BackEnd | Architecture defined; no implementation yet |
| Garantias streaming | FegusDAgent | Domain entities exist; `IEntitySource` and use cases not created |
| Frontend: Garantias feature | Frontend | Navigation items exist in `_nav.ts`; no components implemented |
| Frontend: Validaciones SUGEF UI | Frontend | Navigation items exist; no components implemented |
| Frontend: Generación de XML | Frontend | Navigation items exist; no components implemented |

---

## Not Started

- Validation Engine — rule execution against `fegusconfig.fe_ingestion_deudores_raw`
- XML generation for SUGEF submissions
- Workflow Engine — full lifecycle orchestration beyond ingestion
- AI-assisted validation explanations
- Garantias endpoints in BackEnd API
- Multi-client scaling / partitioning strategy
- Observability / distributed tracing (no OpenTelemetry yet)
- Frontend: Administración → Usuarios (navigation present, no component)
- Frontend: Administración → Parametros (navigation present, no component)

---

## Known Issues / Risks

| Risk | Severity | Notes |
|------|----------|-------|
| `OperacionCredito` streaming disabled | Medium | `sendOperacionCredito` commented out in `DataLoadOrchestrationUseCase.cs:97` |
| Worker config section named `SaludoWorker` | Low | Misleading name; should reflect general worker config |
| No test projects in FegusDAgent solution | Medium | No unit or integration tests; regressions undetected |
| Token cache in `FegusApiTokenProvider` is in-memory | Low | Token lost on worker restart; first request after restart incurs login overhead |
| Regulatory rule complexity | High | SUGEF validation rules are extensive and change periodically |
| Data volume growth | Medium | Binary COPY mitigates insert overhead; query performance needs monitoring at scale |
| `feguslocal` schema dependency | Medium | Agent requires a separate local PostgreSQL instance alongside the main DB |

---

## Configuration Reference

### BackEnd (`appsettings.json`)

| Key | Dev default |
|-----|-------------|
| `ConnectionStrings:Postgres` | `Host=localhost;Port=5433;Database=FegusApp;...` |
| `Jwt:AccessTokenMinutes` | `15` |
| `Jwt:Key` | Secret (min 32 chars) |
| `Jwt:Issuer` | `fegus-api` |
| `Jwt:Audience` | `fegus-app` |
| `IngestionStorage:TempStoragePath` | `C:\Fegus\TempStorage` |
| `Cors:AllowedOrigins` | `http://localhost:4200` |

### FegusDAgent (`appsettings.json`)

| Key | Purpose |
|-----|---------|
| `ConnectionStrings:Postgres` | Local PostgreSQL (`feguslocal` schema) |
| `FegusApi:BaseUrl` | BackEnd API base URL |
| `FegusApi:IdCliente` | Client ID for this agent instance |
| `FegusApi:Username` | Agent service account username |
| `FegusApi:Password` | Agent service account password |
| `IngestionApi:BaseUrl` | Ingestion API base URL (usually same as FegusApi) |
| `Checkpoints:Folder` | Directory for `.chk` checkpoint files |
| `SaludoWorker:ConsumerCount` | Concurrent consumer tasks |
| `SaludoWorker:PollIntervalSeconds` | Polling interval for new boxes |
| `SaludoWorker:ChannelCapacity` | Bounded channel capacity |
| `SaludoWorker:ParallelJobsPerTick` | Jobs enqueued per poll tick |
