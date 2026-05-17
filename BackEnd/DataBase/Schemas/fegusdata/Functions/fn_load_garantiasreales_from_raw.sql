-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_garantiasreales_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.garantiasreales (
        id_cliente, id_load, session_id, seq,
        idgarantiareal, tipobiengarantiareal,
        montoultimatasacionterreno, montoultimatasacionnoterreno,
        fechaultimatasaciongarantia, fechaultimoseguimientogarantia,
        tipomonedatasacion, fechaconstruccion,
        tipopersonatasador, idtasador, tipopersonaempresatasadora, idempresatasadora,
        indicadorpolizagarantiareal, tipocolateralreal,
        porcentajerecuperacioncolateralreal, tiempo, porcentajefactordescuentotiempo,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idgarantiareal',
        (r.payload->>'tipobiengarantiareal')::numeric(5,0),
        (r.payload->>'montoultimatasacionterreno')::numeric(20,2),
        (r.payload->>'montoultimatasacionnoterreno')::numeric(20,2),
        (r.payload->>'fechaultimatasaciongarantia')::date,
        (r.payload->>'fechaultimoseguimientogarantia')::date,
        (r.payload->>'tipomonedatasacion')::numeric(6,0),
        (r.payload->>'fechaconstruccion')::date,
        (r.payload->>'tipopersonatasador')::numeric(2,0),
        r.payload->>'idtasador',
        (r.payload->>'tipopersonaempresatasadora')::numeric(2,0),
        r.payload->>'idempresatasadora',
        r.payload->>'indicadorpolizagarantiareal',
        (r.payload->>'tipocolateralreal')::numeric(2,0),
        (r.payload->>'porcentajerecuperacioncolateralreal')::numeric(5,2),
        (r.payload->>'tiempo')::numeric(2,0),
        (r.payload->>'porcentajefactordescuentotiempo')::numeric(5,2),
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_garantiasreales_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idgarantiareal)
        DO UPDATE SET
            montoultimatasacionterreno              = EXCLUDED.montoultimatasacionterreno,
            montoultimatasacionnoterreno            = EXCLUDED.montoultimatasacionnoterreno,
            porcentajerecuperacioncolateralreal     = EXCLUDED.porcentajerecuperacioncolateralreal,
            updated_at_utc                          = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
