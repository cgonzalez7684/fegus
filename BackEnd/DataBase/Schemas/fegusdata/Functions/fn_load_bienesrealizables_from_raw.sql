-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_bienesrealizables_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.bienesrealizables (
        id_cliente, id_load, session_id, seq,
        tipoadquisicionbien, idbienrealizable, indicadorgarantia, idgarantia,
        idbien, tipobien, fechaadjudicaciondacionbien, saldoregistrocontable,
        tipomonedasaldoregistrocontable, cuentacatalogosugef, tipocatalogosugef,
        fechaultimatasacionbien, montoultimatasacion, tipomonedamontoavaluo,
        tipopersonatasador, idtasador, tipopersonaempresatasadora, idempresatasadora,
        saldocontablecreditocancelado, tipomonedasaldocontablecreditocancelado,
        montoestimacion,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'tipoadquisicionbien',
        r.payload->>'idbienrealizable',
        r.payload->>'indicadorgarantia',
        r.payload->>'idgarantia',
        r.payload->>'idbien',
        r.payload->>'tipobien',
        (r.payload->>'fechaadjudicaciondacionbien')::date,
        (r.payload->>'saldoregistrocontable')::numeric(18,2),
        r.payload->>'tipomonedasaldoregistrocontable',
        r.payload->>'cuentacatalogosugef',
        r.payload->>'tipocatalogosugef',
        (r.payload->>'fechaultimatasacionbien')::date,
        (r.payload->>'montoultimatasacion')::numeric(18,2),
        r.payload->>'tipomonedamontoavaluo',
        r.payload->>'tipopersonatasador',
        r.payload->>'idtasador',
        r.payload->>'tipopersonaempresatasadora',
        r.payload->>'idempresatasadora',
        (r.payload->>'saldocontablecreditocancelado')::numeric(18,2),
        r.payload->>'tipomonedasaldocontablecreditocancelado',
        (r.payload->>'montoestimacion')::numeric(18,2),
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_bienesrealizables_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idbienrealizable)
        DO UPDATE SET
            saldoregistrocontable                  = EXCLUDED.saldoregistrocontable,
            montoultimatasacion                    = EXCLUDED.montoultimatasacion,
            montoestimacion                        = EXCLUDED.montoestimacion,
            updated_at_utc                         = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
