# Domain Structure

## Core Credit Domains

### Deudores (Debtors)

**Status**: Active — API endpoints implemented, FegusDAgent streaming implemented

**Description**: Borrower/debtor records submitted to SUGEF. Each debtor belongs to a client (`id_cliente`) and is identified by `tipo_persona_deudor` + `id_deudor`.

**Key fields**: risk rating (`calificacion_riesgo`), economic sector (`codigo_sector_economico`), delinquency metrics (`dias_atraso`, `saldo_moratoria`), linkage flags (grupo interés económico, vinculado entidad), payment behavior codes, CSD indicators.

**BackEnd entity**: `Domain/Entities/Deudor.cs`  
**Agent entity**: `FegusDAgent.Domain/Entities/Deudor.cs`  
**DB source**: `feguslocal.obtener_deudores_lista(@id_load_local)`  
**API read**: `GET /crediticio/deudores/{idCliente}`, `GET /crediticio/deudores/{idCliente}/{idDeudor}`

---

### OperacionesCredito (Credit Operations)

**Status**: Active — FegusDAgent entity and source implemented; streaming disabled in orchestrator (pending re-enable)

**Description**: Individual credit operations linked to a debtor. Rich domain model with risk metrics (EAD, LGD), disbursement amounts, portfolio type, delinquency days, and operation flags.

**Key fields**: `id_operacion_credito`, `tipo_operacion_sfn`, `EAD`, `LGD_promedio`, `LGD_regulatorio`, `monto_operacion_autorizado`, `monto_desembolsado`, `saldo_principal`, `dias_maxima_morosidad`, `fecha_formalizacion`, `fecha_vencimiento`, `indicador_back_to_back`, `indicador_credito_sindicado`.

**Domain methods**: `UpdateSaldo()`, `UpdateMora()`

**Agent entity**: `FegusDAgent.Domain/Entities/OperacionCredito.cs`  
**DB source**: `FegusDAgent.Infrastructure/Persistence/OperacionCreditoSource.cs`

---

### Garantias (Guarantees & Collateral)

**Status**: Planned — entities defined in FegusDAgent.Domain, no API endpoints yet

**Entities defined**:
- `GarantiaMobiliaria` — movable collateral
- `GarantiaOperacion` — operation-level guarantee linkage
- `Gravamen` — encumbrance / lien
- `Fideicomiso` — trust-based guarantee
- `BienesRealizables` — repossessed assets
- `BienesRealizablesNoReportados` — unreported repossessed assets
- `OperacionBienRealizable` — operation linked to repossessed asset
- `CreditoSindicado` — syndicated credit
- `Codeudor` — co-debtor linkage

---

## Supporting Domains

### Catalogos (SUGEF Regulatory Catalogs)

**Status**: Active — catalogs implemented in frontend (`sugef-catalogs.ts`); DB schema `feguscatalogos` exists

**Description**: Predefined code-to-description mappings used by SUGEF reporting requirements. Examples: `TipoPersona`, `TipoDatos`, `TipoMoneda`, `TipoCarteraCrediticia`, `TipoOperacionSFN`.

**Frontend**: Catalogs drive dropdown editors and tooltips in `GridZComponent` via the `catalog` field in `GridColumnConfig`.

**DB schema**: `feguscatalogos`

---

### Ingestion Engine

**Status**: Active — full pipeline implemented end-to-end

**Description**: The mechanism by which FegusDAgent streams financial data into the BackEnd, which persists it in staging tables for subsequent validation and promotion.

**Key components**:
- `FeBoxDataLoad` — configuration record that triggers a data load cycle
- `IngestionSession` — tracks a single streaming session (lifecycle: `CREATED → RECEIVING → COMPLETED | FAILED`)
- `PostgresCopyStreamWriter` — bulk inserts rows to `fegusconfig.fe_ingestion_deudores_raw` via PostgreSQL binary COPY
- `FileCheckpointStore` — persists last sequence number for resume support
- `HttpIngestionStreamSender` — ProducerStream + gzip + NDJSON

**Session states** (BackEnd): `CREATED`, `RECEIVING`, `COMPLETED`, `FAILED`  
**Box states** (FegusDAgent): `NEW`, `CREATED`, `STAGING`, `VALIDATING`, `CALCULATING`, `COMPLETED`, `ERROR`, `CANCELLED`

---

### Validation Engine

**Status**: In progress — not yet implemented in codebase

**Description**: Rule-based engine that validates promoted data against SUGEF regulatory rules. Outputs error/warning reports per entity.

---

### Workflow Engine

**Status**: Planned

**Description**: Orchestrates the full data load → validate → generate XML → submit lifecycle. Will manage state transitions of `FeBoxDataLoad` through all stages beyond `CREATED`.

---

## Additional Sub-Entities (FegusDAgent Domain)

These entities are defined in `FegusDAgent.Domain/Entities/` and will be streamed as part of future domain areas:

| Entity | Domain Area |
|--------|-------------|
| `ActividadEconomica` | Deudores |
| `IngresoDeudor` | Deudores |
| `CuotaAtrasada` | OperacionesCredito |
| `CuentaPorCobrar` | OperacionesCredito |
| `CuentaPorCobrarNoAsociada` | OperacionesCredito |
| `Modificacion` | OperacionesCredito |
| `OperacionComprada` | OperacionesCredito |
| `OperacionNoReportada` | OperacionesCredito |
| `NaturalezaGasto` | OperacionesCredito |
| `OrigenRecursos` | OperacionesCredito |
| `CambioClimatico` | Transversal |

---

## Domain Independence Rules

- Each domain's data must be independently queryable by `id_cliente`
- Domains must not directly reference other domain's database tables; use API calls or events
- Domain entities in `BackEnd.Domain` and `FegusDAgent.Domain` may intentionally differ — they represent the same business concept from different system perspectives
