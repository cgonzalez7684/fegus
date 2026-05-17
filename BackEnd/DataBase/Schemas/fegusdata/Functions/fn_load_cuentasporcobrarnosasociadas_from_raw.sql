-- Target: ConnectionStringAzure (Azure PostgreSQL)
CREATE OR REPLACE FUNCTION fegusdata.fn_load_cuentasporcobrarnosasociadas_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.cuentasporcobrarnosasociadas (
        id_cliente, id_load, session_id, seq,
        idoperacioncredito, tipopersonadeudor, idpersona, tipomonedamonto,
        montooriginal, tipocatalogosugef, cuentacontablesaldoprincipal, saldoprincipal,
        cuentacontablesaldoproductosporcobrar, saldoproductosporcobrar,
        fecharegistrocontable, fechaexigibilidad, fechavencimiento,
        montoestimacionregistrada, tipodependencia, diasmora,
        created_at_utc, updated_at_utc
    )
    SELECT
        r.id_cliente, r.id_load, r.session_id, r.seq,
        r.payload->>'idoperacioncredito',
        r.payload->>'tipopersonadeudor',
        r.payload->>'idpersona',
        r.payload->>'tipomonedamonto',
        (r.payload->>'montooriginal')::numeric(18,2),
        r.payload->>'tipocatalogosugef',
        r.payload->>'cuentacontablesaldoprincipal',
        (r.payload->>'saldoprincipal')::numeric(18,2),
        r.payload->>'cuentacontablesaldoproductosporcobrar',
        (r.payload->>'saldoproductosporcobrar')::numeric(18,2),
        (r.payload->>'fecharegistrocontable')::date,
        (r.payload->>'fechaexigibilidad')::date,
        (r.payload->>'fechavencimiento')::date,
        (r.payload->>'montoestimacionregistrada')::numeric(18,2),
        r.payload->>'tipodependencia',
        (r.payload->>'diasmora')::integer,
        NOW(), NOW()
    FROM fegusconfig.fe_ingestion_cuentasporcobrarnosasociadas_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, idoperacioncredito)
        DO UPDATE SET
            saldoprincipal             = EXCLUDED.saldoprincipal,
            saldoproductosporcobrar    = EXCLUDED.saldoproductosporcobrar,
            montoestimacionregistrada  = EXCLUDED.montoestimacionregistrada,
            diasmora                   = EXCLUDED.diasmora,
            updated_at_utc             = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty := v_qty; psqlcode := '00000'; psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty := 0; psqlcode := SQLSTATE; psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
