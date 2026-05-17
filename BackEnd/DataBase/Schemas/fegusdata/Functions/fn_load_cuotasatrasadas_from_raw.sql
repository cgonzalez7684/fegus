-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_cuotasatrasadas_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.cuotasatrasadas (
        id_cliente, id_load, session_id, seq,
        tipopersonadeudor, iddeudor, idoperacioncredito, tipocuota,
        numerocuotaatrasada, diasatraso, montocuotaatrasada,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'tipopersonadeudor',
        r.payload->>'iddeudor',
        r.payload->>'idoperacioncredito',
        r.payload->>'tipocuota',
        (r.payload->>'numerocuotaatrasada')::integer,
        (r.payload->>'diasatraso')::integer,
        (r.payload->>'montocuotaatrasada')::numeric(18,2),
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_cuotas_atrasadas_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idoperacioncredito, tipocuota, numerocuotaatrasada)
        DO UPDATE SET
            diasatraso          = EXCLUDED.diasatraso,
            montocuotaatrasada  = EXCLUDED.montocuotaatrasada,
            updated_at_utc      = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
