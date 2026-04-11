# FEGUS Master Context

FEGUS is a SaaS regulatory platform for financial institutions in Costa Rica, focused on validating, processing, and submitting regulatory data aligned with SUGEF (Superintendencia General de Entidades Financieras) requirements.

## Core Principles

- **Multi-tenant**: every table and operation is scoped by `id_cliente`
- **Domain-driven**: business logic lives in the domain layer; infrastructure is a detail
- **Clean Architecture**: strict layer dependencies across all projects
- **High-performance ingestion**: streaming NDJSON over gzip, PostgreSQL binary COPY for bulk insert
- **Regulatory accuracy**: data structures and catalogs follow SUGEF reporting formats

## System Components

| Component | Technology | Role |
|-----------|-----------|------|
| BackEnd | .NET 10, FastEndpoints, MediatR, Dapper | REST API, authentication, ingestion receiver |
| FegusDAgent | .NET 10 Worker Service | Polls local DB, streams financial data to BackEnd |
| Frontend | Angular 21, CoreUI 5.6, AG Grid 35 | Admin UI for data management and configuration |
| Database | PostgreSQL | Primary data store (multi-schema) |
| Cloud | Microsoft Azure | Hosting (App Services, PostgreSQL, Static Web Apps) |
| CI/CD | GitHub Actions | Automated build and deploy |

## Domain Areas

| Domain | Status | Description |
|--------|--------|-------------|
| Deudores | Active | Debtor/borrower regulatory data |
| OperacionesCredito | Active | Credit operation records |
| Garantias | Planned | Collateral and guarantees |
| Catalogos | Active | SUGEF regulatory catalogs |
| Ingestion Engine | Active | Raw data intake pipeline |
| Validation Engine | In progress | Rule-based regulatory validation |
| Workflow Engine | Planned | Process orchestration and state tracking |

## Authentication Model

- JWT Bearer (HS256), 15-minute access tokens
- Refresh tokens (7-day TTL) stored in `fegusseg.fe_refresh_tokens`
- Claims: `sub`, `idcliente`, `username`, `email`, `roles`, `perms`
- Authorization policies: `AuthenticatedUser`, `Ingestion` (requires role `ingestion.agent`)

## Ingestion Pipeline Overview

1. FegusDAgent polls `GET /fegusconfig/box/{idCliente}/next` for a NEW data load box
2. Authenticates with BackEnd, persists box locally, updates remote state to CREATED
3. Creates an ingestion session: `POST /ingestion/sessions`
4. Streams NDJSON rows (gzip-compressed) to `POST /ingestion/sessions/{sessionId}/stream`
5. BackEnd writes rows to `fegusconfig.fe_ingestion_deudores_raw` via PostgreSQL binary COPY
6. Commits the session: `POST /ingestion/sessions/{sessionId}/commit`
7. Checkpoints last sequence number to disk for resume on failure

## Language Conventions

- Business entity names and PostgreSQL identifiers are in **Spanish** (`deudores`, `operacion_credito`, `id_carga_datos`, etc.)
- Code identifiers (classes, methods, variables) are in **English**
- API routes and HTTP verbs are in **English**
