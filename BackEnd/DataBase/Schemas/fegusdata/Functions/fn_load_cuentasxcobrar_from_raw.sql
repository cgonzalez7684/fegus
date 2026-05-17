-- Target: ConnectionStringAzure (Azure PostgreSQL)
-- fe_ingestion_cuentas_cobrar_asociadas_raw → fegusdata.cuentasxcobrar
CREATE OR REPLACE FUNCTION fegusdata.fn_load_cuentasxcobrar_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.cuentasxcobrar (
        id_cliente, id_load, session_id, seq,
        idoperacioncredito, idcuentacobrarasociada, cuentacontablecuentacobrarasociada,
        tipocatalogosugef, saldocuentacobrarasociada, tipomonedacuentacobrarasociada,
        diasatrasocuentacobrarasociada, fecharegistrocuentacobrarasociada,
        fechavencimientocuentacobrarasociada, concepto,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idoperacioncredito',
        r.payload->>'idcuentacobrarasociada',
        r.payload->>'cuentacontablecuentacobrarasociada',
        r.payload->>'tipocatalogosugef',
        (r.payload->>'saldocuentacobrarasociada')::numeric(18,2),
        r.payload->>'tipomonedacuentacobrarasociada',
        (r.payload->>'diasatrasocuentacobrarasociada')::integer,
        (r.payload->>'fecharegistrocuentacobrarasociada')::date,
        (r.payload->>'fechavencimientocuentacobrarasociada')::date,
        r.payload->>'concepto',
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_cuentas_cobrar_asociadas_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idoperacioncredito, idcuentacobrarasociada)
        DO UPDATE SET
            saldocuentacobrarasociada       = EXCLUDED.saldocuentacobrarasociada,
            diasatrasocuentacobrarasociada  = EXCLUDED.diasatrasocuentacobrarasociada,
            updated_at_utc                  = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
