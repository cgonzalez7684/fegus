-- Target: ConnectionStringAzure (Azure PostgreSQL)
-- fe_ingestion_garantias_raw → fegusdata.garantiasoperacion
CREATE OR REPLACE FUNCTION fegusdata.fn_load_garantiasoperacion_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.garantiasoperacion (
        id_cliente, id_load, session_id, seq,
        tipopersonadeudor, iddeudor, idoperacioncredito, tipogarantia, idgarantia,
        indicadorformatraspasobien, idgarantiatraspaso, tipomitigador, tipodocumentolegal,
        valorajustadogarantia, tipoinscripciongarantia, porcentajeresponsabilidadgarantia,
        valornominalgarantia, fechapresentacionregistrogarantia, tipomonedavalornominalgarantia,
        fechaconstituciongarantia, fechavencimientogarantia,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'tipopersonadeudor',
        r.payload->>'iddeudor',
        r.payload->>'idoperacioncredito',
        r.payload->>'tipogarantia',
        r.payload->>'idgarantia',
        r.payload->>'indicadorformatraspasobien',
        r.payload->>'idgarantiatraspaso',
        r.payload->>'tipomitigador',
        r.payload->>'tipodocumentolegal',
        (r.payload->>'valorajustadogarantia')::numeric(18,2),
        r.payload->>'tipoinscripciongarantia',
        (r.payload->>'porcentajeresponsabilidadgarantia')::numeric(5,2),
        (r.payload->>'valornominalgarantia')::numeric(18,2),
        (r.payload->>'fechapresentacionregistrogarantia')::date,
        r.payload->>'tipomonedavalornominalgarantia',
        (r.payload->>'fechaconstituciongarantia')::date,
        (r.payload->>'fechavencimientogarantia')::date,
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_garantias_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, seq, idoperacioncredito, tipopersonadeudor, iddeudor, idgarantia, tipomitigador, tipodocumentolegal)
        DO UPDATE SET
            valorajustadogarantia              = EXCLUDED.valorajustadogarantia,
            porcentajeresponsabilidadgarantia  = EXCLUDED.porcentajeresponsabilidadgarantia,
            valornominalgarantia               = EXCLUDED.valornominalgarantia,
            updated_at_utc                     = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
