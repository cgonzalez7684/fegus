-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_naturalezagasto_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.naturalezagasto (
        id_cliente, id_load, session_id, seq,
        idoperacioncredito, tiponaturalezagasto, porcentajenaturalezagasto,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idoperacioncredito',
        r.payload->>'tiponaturalezagasto',
        (r.payload->>'porcentajenaturalezagasto')::numeric(5,2),
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_naturalezagasto_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idoperacioncredito, tiponaturalezagasto)
        DO UPDATE SET
            porcentajenaturalezagasto = EXCLUDED.porcentajenaturalezagasto,
            updated_at_utc            = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
