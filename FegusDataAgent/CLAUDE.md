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
Entities are streamed via `IEntitySource<T>.StreamAsync()` (returns `IAsyncEnumerable<T>`) to avoid loading large datasets into memory. `HttpIngestionStreamSender` writes gzip-compressed NDJSON using `System.IO.Pipelines` (`ProducerStream`). Each row is prefixed with an incrementing sequence number to support checkpoint-based resume.

### Checkpointing
`ICheckpointStore` (file-based impl) persists the last-sent sequence number per `sessionId`. On restart, ingestion resumes from the last saved sequence rather than from scratch.

### Fegus API Authentication
`FegusApiTokenProvider` is a singleton that caches a Bearer token and proactively refreshes it after 55 minutes using `SemaphoreSlim` double-check locking. Credentials come from `FegusApi` config section.

### Worker Concurrency
`Worker.cs` uses `System.Threading.Channels` for a bounded producer-consumer queue. A single producer enqueues jobs on a timer (`PollIntervalSeconds`); multiple consumers (`ConsumerCount`) process them in parallel. Configuration is under `SaludoWorker` in appsettings.

### PostgreSQL Access
Entities are streamed from PostgreSQL stored functions (e.g., `feguslocal.obtener_deudores_lista(@id_load_local)`) using Dapper + Npgsql. The `NpgsqlConnectionFactory` creates connections from the `ConnectionStrings:Postgres` config entry.

## Configuration Sections (appsettings.json)

| Section | Purpose |
|---|---|
| `ConnectionStrings:Postgres` | PostgreSQL connection string |
| `IngestionApi:BaseUrl` | Target HTTP ingestion API |
| `FegusApi` | BaseUrl, IdCliente, Username, Password for source API |
| `SaludoWorker` | Worker pool settings (PollIntervalSeconds, ConsumerCount, etc.) |
| `Checkpoints:Folder` | Directory for `.chk` checkpoint files |

## Domain Entities

The domain contains 20+ financial entities. The two primary streaming entities are:
- **`Deudor`** — borrower/debtor with 50+ fields covering risk classification, delinquency, and economic sector data.
- **`OperacionCredito`** — credit operation with ~40 fields including EAD/LGD risk metrics, disbursements, and portfolio type. Has domain methods `UpdateSaldo()` and `UpdateMora()`.
- **`FeBoxDataLoad`** — configuration record from the Fegus API describing a data load job (state, AsofDate, IsActive).

## Adding a New Entity Stream

1. Add entity class in `FegusDAgent.Domain/Entities/`
2. Add `IEntitySource<NewEntity>` or reuse the generic interface in `FegusDAgent.Domain/Interfaces/`
3. Implement `IEntitySource<NewEntity>` in `FegusDAgent.Infrastructure/Persistence/` calling a PostgreSQL function
4. Add a use case in `FegusDAgent.Application/UseCases/Ingestion/` following the pattern of `SendDeudoresUseCase`
5. Wire it into `DataLoadOrchestrationUseCase` (the central orchestrator in `UseCases/`) — add it to the constructor and the `Task.WhenAll(...)` call
6. Register the source and use case in `FegusDAgent.Worker/Program.cs`


## Dependency Injection Rules

- Every service, repository, or handler created must be registered in `Program.cs`.
- Use `Scoped` lifetime for all application services unless explicitly stated otherwise.
- Do NOT use `Singleton` for services that depend on database access.
- Do NOT leave services unregistered.
