-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_cambioclimatico_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.cambioclimatico (
        id_cliente, id_load, session_id, seq,
        idoperacioncredito, tipotema, tiposubtema, tipoactividad, tipoambito,
        tipofuentefinanciamiento, tipofondofinanciamiento, saldomontoclimatico,
        codigomodalidad,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idoperacioncredito',
        r.payload->>'tipotema',
        r.payload->>'tiposubtema',
        r.payload->>'tipoactividad',
        r.payload->>'tipoambito',
        r.payload->>'tipofuentefinanciamiento',
        r.payload->>'tipofondofinanciamiento',
        (r.payload->>'saldomontoclimatico')::numeric(18,2),
        r.payload->>'codigomodalidad',
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_cambioclimatico_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idoperacioncredito)
        DO UPDATE SET
            saldomontoclimatico = EXCLUDED.saldomontoclimatico,
            updated_at_utc      = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
