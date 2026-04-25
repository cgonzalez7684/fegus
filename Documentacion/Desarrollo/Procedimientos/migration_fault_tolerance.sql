-- =============================================================================
-- Migration: Fault-tolerance & retry hardening for FegusDataAgent
-- =============================================================================
-- Workstreams:
--   W3: Per-box attempt counter + last_error_message + Max-N -> ERROR transition
--   W4: Orphan ingestion session reaper support
--
-- Apply on the BackEnd PostgreSQL database (cloud / FegusApp).
-- All changes are idempotent: safe to run multiple times.
-- =============================================================================


-- -----------------------------------------------------------------------------
-- W3.1  Add attempt_count and last_error_message to fe_box_data_load
-- -----------------------------------------------------------------------------
ALTER TABLE fegusconfig.fe_box_data_load
    ADD COLUMN IF NOT EXISTS attempt_count       INTEGER NOT NULL DEFAULT 0,
    ADD COLUMN IF NOT EXISTS last_error_message  TEXT    NULL;


-- -----------------------------------------------------------------------------
-- W3.2  Update fn_box_data_load_update to accept and persist new fields
--
-- Two new optional input params at the tail. Existing callers that omit them
-- will fall back to coalesce(NEW, OLD) semantics: the row keeps its current
-- values when the agent does not pass the field.
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS fegusconfig.fn_box_data_load_update(
    integer, bigint, bigint, text, text);

CREATE OR REPLACE FUNCTION fegusconfig.fn_box_data_load_update(
    p_id_cliente            integer,
    p_id_load               bigint,
    p_id_load_local         bigint,
    p_state_code            text,
    p_is_active             text,
    p_attempt_count         integer DEFAULT NULL,
    p_last_error_message    text    DEFAULT NULL
)
RETURNS TABLE (
    pqty        integer,
    psqlcode    integer,
    psqlmessage text
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    UPDATE fegusconfig.fe_box_data_load
    SET id_load_local       = COALESCE(p_id_load_local,      id_load_local),
        state_code          = COALESCE(p_state_code,         state_code),
        is_active           = COALESCE(p_is_active,          is_active),
        attempt_count       = COALESCE(p_attempt_count,      attempt_count),
        last_error_message  = CASE
                                  WHEN p_last_error_message IS NULL
                                      THEN last_error_message
                                  ELSE p_last_error_message
                              END,
        updated_at_utc      = NOW()
    WHERE id_cliente = p_id_cliente
      AND id_load    = p_id_load;

    GET DIAGNOSTICS v_qty = ROW_COUNT;

    RETURN QUERY SELECT v_qty, 0, 'OK'::text;
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY SELECT 0, SQLSTATE::int, SQLERRM;
END;
$$;


-- -----------------------------------------------------------------------------
-- W3.3  Update fn_next_box_data_load_get to return new columns
--
-- Caller (BoxDataRepository.GetNextFeBoxDataLoadAsync) projects the new fields
-- and the agent uses them to decide attempt-cap behavior.
-- -----------------------------------------------------------------------------
DROP FUNCTION IF EXISTS fegusconfig.fn_next_box_data_load_get(integer);

CREATE OR REPLACE FUNCTION fegusconfig.fn_next_box_data_load_get(
    p_id_cliente integer
)
RETURNS TABLE (
    id_cliente          integer,
    id_load             bigint,
    id_load_local       bigint,
    state_code          text,
    is_active           text,
    asofdate            date,
    created_at_utc      timestamp,
    updated_at_utc      timestamp,
    attempt_count       integer,
    last_error_message  text,
    pqty                integer,
    psqlcode            integer,
    psqlmessage         text
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        b.id_cliente,
        b.id_load,
        b.id_load_local,
        b.state_code,
        b.is_active,
        b.asofdate,
        b.created_at_utc,
        b.updated_at_utc,
        b.attempt_count,
        b.last_error_message,
        1                AS pqty,
        0                AS psqlcode,
        'OK'::text       AS psqlmessage
    FROM fegusconfig.fe_box_data_load b
    WHERE b.id_cliente = p_id_cliente
      AND b.is_active  = 'A'
      AND b.state_code <> 'ERROR'
      AND b.state_code <> 'COMPLETED'
    ORDER BY b.created_at_utc ASC
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN QUERY SELECT
            NULL::integer, NULL::bigint, NULL::bigint,
            NULL::text, NULL::text, NULL::date,
            NULL::timestamp, NULL::timestamp,
            NULL::integer, NULL::text,
            0, 0, 'NO_ROWS'::text;
    END IF;
EXCEPTION WHEN OTHERS THEN
    RETURN QUERY SELECT
        NULL::integer, NULL::bigint, NULL::bigint,
        NULL::text, NULL::text, NULL::date,
        NULL::timestamp, NULL::timestamp,
        NULL::integer, NULL::text,
        0, SQLSTATE::int, SQLERRM;
END;
$$;


-- -----------------------------------------------------------------------------
-- W4  Orphan ingestion session reaper support
--
-- The IngestionSessionReaperHostedService runs on an interval and calls the
-- repository, which executes:
--
--   UPDATE fegusconfig.fe_ingestion_sessions
--   SET session_state_code = 'FAILED', updated_at_utc = NOW()
--   WHERE session_state_code IN ('CREATED','RECEIVING')
--     AND created_at_utc < NOW() - @OlderThan::interval
--
-- This UPDATE relies on the table already having an updated_at_utc column.
-- If the column does not exist, add it now so the reaper has somewhere to
-- record the FAILED transition timestamp.
-- -----------------------------------------------------------------------------
ALTER TABLE fegusconfig.fe_ingestion_sessions
    ADD COLUMN IF NOT EXISTS updated_at_utc timestamp NULL;

-- Optional: index to keep the reaper UPDATE cheap as session count grows.
CREATE INDEX IF NOT EXISTS ix_fe_ingestion_sessions_state_created
    ON fegusconfig.fe_ingestion_sessions (session_state_code, created_at_utc);

-- =============================================================================
-- End of migration
-- =============================================================================
