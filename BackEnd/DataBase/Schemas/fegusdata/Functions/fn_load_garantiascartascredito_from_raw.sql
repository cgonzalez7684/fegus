-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_garantiascartascredito_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.garantiascartascredito (
        id_cliente, id_load, session_id, seq,
        idgarantiacartacredito, tipomitigadorcartacredito, fechaconstitucion, fechavencimiento,
        tipopersona, identidadcartacredito, valornominalgarantia, tipomonedavalornominal,
        tipoasignacioncalificacion, codigocalificacioncategoria, factor_y,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idgarantiacartacredito',
        (r.payload->>'tipomitigadorcartacredito')::numeric(2,0),
        (r.payload->>'fechaconstitucion')::date,
        (r.payload->>'fechavencimiento')::date,
        (r.payload->>'tipopersona')::numeric(2,0),
        r.payload->>'identidadcartacredito',
        (r.payload->>'valornominalgarantia')::numeric(20,2),
        (r.payload->>'tipomonedavalornominal')::numeric(6,0),
        (r.payload->>'tipoasignacioncalificacion')::numeric(1,0),
        (r.payload->>'codigocalificacioncategoria')::numeric(2,0),
        (r.payload->>'factor_y')::numeric(3,2),
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_garantiascartascredito_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idgarantiacartacredito)
        DO UPDATE SET
            valornominalgarantia = EXCLUDED.valornominalgarantia,
            factor_y             = EXCLUDED.factor_y,
            updated_at_utc       = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
