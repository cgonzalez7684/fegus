-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_garantiasvalores_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.garantiasvalores (
        id_cliente, id_load, session_id, seq,
        idgarantiavalor, tipoclasificacioninstrumento, tipopersona, idemisor,
        idinstrumento, serieinstrumento, premio, codigoisin,
        tipoasignacioncalificacion, categoriacalificacion, codigocalificacionriesgo,
        codigoempresacalificadora, valorfacial, tipomonedavalorfacial,
        valormercado, tipomonedavalormercado, fechaconstitucion, fechavencimiento,
        tipocolateralfinanciero, codigocalificacioninstrumento, porcentajeajusterc,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idgarantiavalor',
        (r.payload->>'tipoclasificacioninstrumento')::numeric(1,0),
        (r.payload->>'tipopersona')::numeric(2,0),
        r.payload->>'idemisor',
        r.payload->>'idinstrumento',
        r.payload->>'serieinstrumento',
        (r.payload->>'premio')::numeric(9,6),
        r.payload->>'codigoisin',
        (r.payload->>'tipoasignacioncalificacion')::numeric(1,0),
        (r.payload->>'categoriacalificacion')::numeric(1,0),
        r.payload->>'codigocalificacionriesgo',
        (r.payload->>'codigoempresacalificadora')::numeric(2,0),
        (r.payload->>'valorfacial')::numeric(20,2),
        (r.payload->>'tipomonedavalorfacial')::numeric(6,0),
        (r.payload->>'valormercado')::numeric(20,2),
        (r.payload->>'tipomonedavalormercado')::numeric(6,0),
        (r.payload->>'fechaconstitucion')::date,
        (r.payload->>'fechavencimiento')::date,
        (r.payload->>'tipocolateralfinanciero')::numeric(2,0),
        (r.payload->>'codigocalificacioninstrumento')::numeric(2,0),
        (r.payload->>'porcentajeajusterc')::numeric(5,2),
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_garantiasvalores_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idgarantiavalor)
        DO UPDATE SET
            valormercado       = EXCLUDED.valormercado,
            porcentajeajusterc = EXCLUDED.porcentajeajusterc,
            updated_at_utc     = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
