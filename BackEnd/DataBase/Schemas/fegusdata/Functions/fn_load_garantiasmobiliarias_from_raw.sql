-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_garantiasmobiliarias_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.garantiasmobiliarias (
        id_cliente, id_load, session_id, seq,
        idgarantiamobiliaria, fechapublicidadgm, montogarantiamobiliaria,
        fechavencimientogm, fechamontoreferencia, montoreferencia, tipomonedamontoreferencia,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idgarantiamobiliaria',
        (r.payload->>'fechapublicidadgm')::date,
        (r.payload->>'montogarantiamobiliaria')::numeric(18,2),
        (r.payload->>'fechavencimientogm')::date,
        (r.payload->>'fechamontoreferencia')::date,
        (r.payload->>'montoreferencia')::numeric(18,2),
        r.payload->>'tipomonedamontoreferencia',
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_garantiasmobiliarias_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idgarantiamobiliaria)
        DO UPDATE SET
            montogarantiamobiliaria = EXCLUDED.montogarantiamobiliaria,
            montoreferencia         = EXCLUDED.montoreferencia,
            updated_at_utc          = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
