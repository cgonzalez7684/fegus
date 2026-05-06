# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run Commands

```bash
dotnet build                                            # Build entire solution
dotnet run --project FegusDAgent.Worker                # Run the worker locally
dotnet publish -c Release --project FegusDAgent.Worker # Publish for deployment
```

There are no test projects currently.

## Architecture

This is a .NET 10 background worker service following **Clean Architecture**:

```
FegusDAgent.Domain          ← No dependencies; defines entities and interfaces
FegusDAgent.Application     ← Depends on Domain; orchestrates use cases
FegusDAgent.Infrastructure  ← Depends on Application+Domain; implements interfaces
FegusDAgent.Worker          ← Depends on all layers; DI wiring + BackgroundService
```

**Data flow:** `DataLoadOrchestrationUseCase` (the central entry point) polls the Fegus API for a `FeBoxDataLoad` config box, authenticates, creates a local record, updates remote state, then streams large financial datasets from PostgreSQL compressed as NDJSON over gzip to the BackEnd Ingestion API.

**Use case folder layout:**
```
UseCases/
  Fegus/          ← Fegus API interactions (auth, box polling, box update)
  FegusLocal/     ← Local DB operations (create local box record)
  Ingestion/      ← Dataset streaming (SendDeudoresUseCase, SendOperacionCreditoUseCase)
  DataLoadOrchestrationUseCase.cs  ← Orchestrates the full cycle
```

## Key Concepts

### Streaming Pipeline
Entities are streamed via `IEntitySource<T>.GetDataStreamAsync()` (returns `IAsyncEnumerable<T>`) to avoid loading large datasets into memory. `HttpIngestionStreamSender` writes gzip-compressed NDJSON using `System.IO.Pipelines` (`ProducerStream`). Each row is prefixed with an incrementing sequence number to support resume-on-failure.

### Session-Based Resume (Checkpointing)
The last-sent sequence number is tracked server-side in `IngestionSession.LastSequencePersisted`. Before creating a new session, each send use case calls `GetInFlightSessionAsync()` — if the backend already has an open session for that (box, dataset) pair, it reuses it and resumes from `LastSequencePersisted + 1` rather than restarting from scratch.

### HTTP Resilience and Timeouts
- Most HTTP clients use a **Polly retry handler** (4 retries, exponential backoff + jitter), configured in `Program.cs`.
- **The streaming sender has no retry** — a gzip pipe cannot be replayed mid-transfer. Resilience happens at the use-case level by reusing the existing in-flight session and resuming from the last checkpoint.
- Timeouts: config/auth clients **30 s**, ingestion session client **10 min**, streaming sender **30 min**.

### Fegus API Authentication
`FegusApiTokenProvider` is a singleton that caches a Bearer token and proactively refreshes it after 55 minutes using `SemaphoreSlim` double-check locking. Credentials come from `FegusApi` config section.

### Worker Concurrency
`Worker.cs` uses `System.Threading.Channels` for a bounded producer-consumer queue. A single producer enqueues jobs on a timer (`PollIntervalSeconds`); multiple consumers (`ConsumerCount`) process them in parallel. A `_jobGate` semaphore inside the worker ensures only **one orchestration runs at a time**, preventing concurrent box state mutations. Configuration is under `SaludoWorker` in appsettings.

### PostgreSQL Access
Entities are streamed from PostgreSQL stored functions (e.g., `feguslocal.obtener_deudores_lista(@id_load_local)`, `feguslocal.obtener_operacionescredito_lista(@id_load_local)`) using Dapper + Npgsql. The `NpgsqlConnectionFactory` creates connections from the `ConnectionStrings:Postgres` config entry.

### Box State Machine
`DataLoadState` is a sealed-class enum with these states (not a C# `enum`):
`NEW → CREATED → STAGING → VALIDATING → CALCULATING → COMPLETED`  
Error paths: any state can transition to `ERROR` (after `MaxAttemptsPerBox` is exceeded) or `CANCELLED`. Only boxes in `NEW` or `CREATED` state are eligible to be picked up by the orchestrator.

## Configuration Sections (appsettings.json)

| Section | Purpose |
|---|---|
| `ConnectionStrings:Postgres` | PostgreSQL connection string |
| `IngestionApi:BaseUrl` | Target HTTP ingestion API |
| `FegusApi` | BaseUrl, IdCliente, Username, Password for source API |
| `SaludoWorker` | Worker pool settings (PollIntervalSeconds, ConsumerCount, MaxAttemptsPerBox, etc.) |

## Domain Entities

The domain contains 20+ financial entities. The two primary streaming entities are:
- **`Deudor`** — borrower/debtor with 50+ fields covering risk classification, delinquency, and economic sector data.
- **`OperacionCredito`** — credit operation with ~40 fields including EAD/LGD risk metrics, disbursements, and portfolio type.
- **`FeBoxDataLoad`** — configuration record from the Fegus API describing a data load job (state, AsofDate, IsActive, AttemptCount).

## Adding a New Entity Stream

1. Add entity class in `FegusDAgent.Domain/Entities/`
2. Reuse the generic `IEntitySource<T>` interface in `FegusDAgent.Domain/Interfaces/`
3. Implement `IEntitySource<NewEntity>` in `FegusDAgent.Infrastructure/Persistence/` calling a PostgreSQL function
4. Add a use case in `FegusDAgent.Application/UseCases/Ingestion/` following the pattern of `SendDeudoresUseCase`
5. Wire it into `DataLoadOrchestrationUseCase` — add it to the constructor and the `Task.WhenAll(...)` call
6. Add the dataset name to `DataSetNameIngestion` in `FegusDAgent.Domain/Enums/`
7. Register the source and use case in `FegusDAgent.Worker/Program.cs`

## Database Reference

The folder `FegusDataAgent/DataBase/Schemas/feguslocal/` contains the authoritative SQL scripts for every object in the local PostgreSQL database (`feguslocal` schema). **Always read the relevant files here before writing or modifying any query, stored function call, or entity mapping.**

```
DataBase/Schemas/feguslocal/
  Tables/       ← actividadeconomica, bienesrealizables, bienesrealizablesnoreportados, cambioclimatico, codeudores, creditossindicados, cuentasporcobrarnosasociadas, cuentasxcobrar, cuotasatrasadas, deudores, fe_box_data_load, fideicomiso, garantiascartascredito, garantiasfacturascedidas, garantiasfiduciarias, garantiasmobiliarias, garantiasoperacion, garantiaspolizas, garantiasreales, garantiasvalores, gravamenes, ingresodeudores, modificacion, naturalezagasto, operacionesbienesrealizables, operacionescompradas, operacionescredito, operacionesnoreportadas, origenrecursos
  Functions/    ← obtener_deudores_lista, obtener_operacionescredito_lista,
                   obtener_garantiasoperacion_lista, generar_id_fegus, etc.
  Procedures/   ← generar_operaciones_deudor, gerancion_datos_dummy
  Sequences/    ← seq_deudor, seq_garantia, seq_operacion
  Types/        ← Custom PostgreSQL types
```

The following outlines the relationship between a database table, a C# entity, and a PostgreSQL function that allows querying the table to create data collections.
```
[actividadeconomica] --> [ActividadEconomica] --> [obtener_actividadeconomica_lista]
[bienesrealizables] --> [BienesRealizables] --> [obtener_bienesrealizables_lista]
[bienesrealizablesnoreportados] --> [BienesRealizablesNoReportados] --> [obtener_bienesrealizablesnoreportados_lista]
[cambioclimatico] --> [CambioClimatico] --> [obtener_cambioclimatico_lista]
[codeudores] --> [Codeudor] --> [obtener_codeudores_lista]
[creditossindicados] --> [CreditoSindicado] --> [obtener_creditossindicados_lista]
[cuentasporcobrarnosasociadas] --> [CuentaPorCobrarNoAsociada] --> [obtener_cuentasporcobrarnosasociadas_lista]
[cuentasxcobrar] --> [CuentaPorCobrar] --> [obtener_cuentasxcobrar_lista]
[cuotasatrasadas] --> [CuotaAtrasada] --> [obtener_cuotasatrasadas_lista]
[deudores] --> [Deudor] --> [obtener_deudores_lista]
[fideicomiso] --> [Fideicomiso] --> [obtener_fideicomiso_lista]
[garantiasmobiliarias] --> [GarantiaMobiliaria] --> [obtener_garantiasmobiliarias_lista]
[garantiasoperacion] --> [GarantiaOperacion] --> [obtener_garantiasoperacion_lista]
[gravamenes] --> [Gravamen] --> [obtener_gravamenes_lista]
[ingresodeudores] --> [IngresoDeudor] --> [obtener_ingresodeudores_lista]
[modificacion] --> [Modificacion] --> [obtener_modificacion_lista]
[naturalezagasto] --> [NaturalezaGasto] --> [obtener_naturalezagasto_lista]
[operacionesbienesrealizables] --> [OperacionBienRealizable] --> [obtener_operacionesbienesrealizables_lista]
[operacionescompradas] --> [OperacionComprada] --> [obtener_operacionescompradas_lista]
[operacionescredito] --> [OperacionCredito] --> [obtener_operacionescredito_lista]
[operacionesnoreportadas] --> [OperacionNoReportada] --> [obtener_operacionesnoreportadas_lista]
[origenrecursos] --> [OrigenRecursos] --> [obtener_origenrecursos_lista]
[garantiasfiduciarias] --> [GarantiaFiduciaria] --> [obtener_garantiasfiduciarias_lista]
[garantiasvalores] --> [GarantiaValor] --> [obtener_garantiasvalores_lista]
[garantiasreales] --> [GarantiaReal] --> [obtener_garantiasreales_lista]
[garantiasfacturascedidas] --> [GarantiasFacturaCedida] --> [obtener_garantiasfacturascedidas_lista]
[garantiascartascredito] --> [GarantiaCartaCredito] --> [obtener_garantiascartascredito_lista]
[garantiaspolizas] --> [GarantiaPoliza] --> [obtener_garantiaspolizas_lista]
```

Use these scripts to:
- Confirm exact column names and types before mapping to domain entity properties.
- Check function signatures (parameters, return columns) before calling via Dapper.
- Understand which `obtener_*_lista` function corresponds to each entity stream.
- Keep scripts up to date whenever a schema change is deployed to the local DB.

## Dependency Injection Rules

- Every service, repository, or handler created must be registered in `Program.cs`.
- Use `Scoped` lifetime for all application services unless explicitly stated otherwise.
- Do NOT use `Singleton` for services that depend on database access.
- Do NOT leave services unregistered.
