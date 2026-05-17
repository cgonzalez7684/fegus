-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_garantiasfiduciarias_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.garantiasfiduciarias (
        id_cliente, id_load, session_id, seq,
        idgarantiafiduciaria, tipopersona, idfiador,
        salarionetofiador, fechaverificacionasalariado, montoavalado,
        porcentajemitigacionfondo, porcentajeestimacionminimofondo,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idgarantiafiduciaria',
        (r.payload->>'tipopersona')::numeric(2,0),
        r.payload->>'idfiador',
        (r.payload->>'salarionetofiador')::numeric(20,2),
        (r.payload->>'fechaverificacionasalariado')::date,
        (r.payload->>'montoavalado')::numeric(20,2),
        (r.payload->>'porcentajemitigacionfondo')::numeric(5,2),
        (r.payload->>'porcentajeestimacionminimofondo')::numeric(5,2),
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_garantiasfiduciarias_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idgarantiafiduciaria)
        DO UPDATE SET
            salarionetofiador              = EXCLUDED.salarionetofiador,
            montoavalado                   = EXCLUDED.montoavalado,
            porcentajemitigacionfondo      = EXCLUDED.porcentajemitigacionfondo,
            updated_at_utc                 = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
