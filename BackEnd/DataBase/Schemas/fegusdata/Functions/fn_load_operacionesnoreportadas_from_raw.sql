-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_operacionesnoreportadas_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.operacionesnoreportadas (
        id_cliente, id_load, session_id, seq,
        tipopersona, iddeudor, idoperacion, motivoliquidacion, fechaliquidacion,
        saldoprincipalliquidado, saldoproductosliquidado, idoperacionnueva,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'tipopersona',
        r.payload->>'iddeudor',
        r.payload->>'idoperacion',
        r.payload->>'motivoliquidacion',
        (r.payload->>'fechaliquidacion')::date,
        (r.payload->>'saldoprincipalliquidado')::numeric(18,2),
        (r.payload->>'saldoproductosliquidado')::numeric(18,2),
        r.payload->>'idoperacionnueva',
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_operacionesnoreportadas_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idoperacion)
        DO UPDATE SET
            saldoprincipalliquidado  = EXCLUDED.saldoprincipalliquidado,
            saldoproductosliquidado  = EXCLUDED.saldoproductosliquidado,
            updated_at_utc           = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
