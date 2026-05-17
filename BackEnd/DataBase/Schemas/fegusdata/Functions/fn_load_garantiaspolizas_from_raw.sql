-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_garantiaspolizas_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.garantiaspolizas (
        id_cliente, id_load, session_id, seq,
        idgarantia, tipogarantia, tipobiengarantia, tipopoliza,
        montopoliza, fechavencimientopoliza, indicadorcoberturaspoliza,
        tipopersonabeneficiario, idbeneficiario,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idgarantia',
        (r.payload->>'tipogarantia')::numeric(5,0),
        (r.payload->>'tipobiengarantia')::numeric(5,0),
        (r.payload->>'tipopoliza')::numeric(2,0),
        (r.payload->>'montopoliza')::numeric(20,2),
        (r.payload->>'fechavencimientopoliza')::date,
        r.payload->>'indicadorcoberturaspoliza',
        (r.payload->>'tipopersonabeneficiario')::numeric(2,0),
        r.payload->>'idbeneficiario',
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_garantiaspolizas_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idgarantia, tipogarantia, tipobiengarantia, tipopoliza, fechavencimientopoliza)
        DO UPDATE SET
            montopoliza    = EXCLUDED.montopoliza,
            updated_at_utc = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
