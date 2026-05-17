-- Target: ConnectionStringAzure (Azure PostgreSQL)
-- Transfers raw deudores payload from fegusconfig staging to fegusdata.deudores.
-- Idempotent via ON CONFLICT DO UPDATE.

CREATE OR REPLACE FUNCTION fegusdata.fn_load_deudores_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
DECLARE
    v_qty integer := 0;
BEGIN
    INSERT INTO fegusdata.deudores (
        id_cliente,
        id_load,
        session_id,
        seq,
        tipodeudorsfn,
        tipopersonadeudor,
        iddeudor,
        codigosectoreconomico,
        tipocapacidadpago,
        saldototalsegmentacion,
        tipocondicionespecialdeudor,
        fechacalificacionriesgo,
        tipoindicadorgeneradordivisas,
        tipoasignacioncalificacion,
        categoriacalificacion,
        calificacionriesgo,
        codigoempresacalificadora,
        indicadorvinculadoentidad,
        indicadorvinculadogrupofinanciero,
        idgrupointereseconomico,
        tipocomportamientopago,
        tipoactividadeconomicadeudor,
        tipocomportamientopagosbd,
        tipobeneficiariosbd,
        totaloperacionesreestructuradassbd,
        tipoindicadorgeneradordivisassbd,
        riesgocambiariodeudor,
        montoingresototaldeudor,
        totalcargamensualcsd,
        indicadorcsd,
        indicadorcic,
        saldomoramayorultmeses1421,
        nummesesmoramayor1421,
        saldomoramayorultmeses1516,
        nummesesmoramayor1516,
        numdiasatraso1421,
        numdiasatraso1516,
        created_at_utc,
        updated_at_utc
    )
    SELECT
        r.id_cliente,
        r.id_load,
        r.session_id,
        r.seq,
        (r.payload->>'tipodeudorsfn')::integer,
        (r.payload->>'tipopersonadeudor')::numeric,
        r.payload->>'iddeudor',
        (r.payload->>'codigosectoreconomico')::numeric,
        (r.payload->>'tipocapacidadpago')::integer,
        (r.payload->>'saldototalsegmentacion')::numeric,
        (r.payload->>'tipocondicionespecialdeudor')::integer,
        r.payload->>'fechacalificacionriesgo',
        (r.payload->>'tipoindicadorgeneradordivisas')::integer,
        (r.payload->>'tipoasignacioncalificacion')::integer,
        (r.payload->>'categoriacalificacion')::numeric,
        r.payload->>'calificacionriesgo',
        (r.payload->>'codigoempresacalificadora')::numeric,
        r.payload->>'indicadorvinculadoentidad',
        r.payload->>'indicadorvinculadogrupofinanciero',
        (r.payload->>'idgrupointereseconomico')::numeric,
        (r.payload->>'tipocomportamientopago')::integer,
        r.payload->>'tipoactividadeconomicadeudor',
        (r.payload->>'tipocomportamientopagosbd')::integer,
        (r.payload->>'tipobeneficiariosbd')::integer,
        (r.payload->>'totaloperacionesreestructuradassbd')::integer,
        (r.payload->>'tipoindicadorgeneradordivisassbd')::integer,
        (r.payload->>'riesgocambiariodeudor')::integer,
        (r.payload->>'montoingresototaldeudor')::numeric,
        (r.payload->>'totalcargamensualcsd')::numeric,
        (r.payload->>'indicadorcsd')::numeric,
        r.payload->>'indicadorcic',
        (r.payload->>'saldomoramayorultmeses1421')::numeric,
        (r.payload->>'nummesesmoramayor1421')::integer,
        (r.payload->>'saldomoramayorultmeses1516')::numeric,
        (r.payload->>'nummesesmoramayor1516')::integer,
        (r.payload->>'numdiasatraso1421')::integer,
        (r.payload->>'numdiasatraso1516')::integer,
        NOW(),
        NOW()
    FROM fegusconfig.fe_ingestion_deudores_raw r
    WHERE r.id_cliente = p_id_cliente
      AND r.id_load    = p_id_load
    ON CONFLICT (id_cliente, id_load, session_id, tipopersonadeudor, iddeudor)
        DO UPDATE SET
            tipodeudorsfn                   = EXCLUDED.tipodeudorsfn,
            codigosectoreconomico           = EXCLUDED.codigosectoreconomico,
            tipocapacidadpago               = EXCLUDED.tipocapacidadpago,
            saldototalsegmentacion          = EXCLUDED.saldototalsegmentacion,
            tipocondicionespecialdeudor     = EXCLUDED.tipocondicionespecialdeudor,
            fechacalificacionriesgo         = EXCLUDED.fechacalificacionriesgo,
            tipoindicadorgeneradordivisas   = EXCLUDED.tipoindicadorgeneradordivisas,
            tipoasignacioncalificacion      = EXCLUDED.tipoasignacioncalificacion,
            categoriacalificacion           = EXCLUDED.categoriacalificacion,
            calificacionriesgo              = EXCLUDED.calificacionriesgo,
            codigoempresacalificadora       = EXCLUDED.codigoempresacalificadora,
            indicadorvinculadoentidad       = EXCLUDED.indicadorvinculadoentidad,
            indicadorvinculadogrupofinanciero = EXCLUDED.indicadorvinculadogrupofinanciero,
            idgrupointereseconomico         = EXCLUDED.idgrupointereseconomico,
            tipocomportamientopago          = EXCLUDED.tipocomportamientopago,
            tipoactividadeconomicadeudor    = EXCLUDED.tipoactividadeconomicadeudor,
            tipocomportamientopagosbd       = EXCLUDED.tipocomportamientopagosbd,
            tipobeneficiariosbd             = EXCLUDED.tipobeneficiariosbd,
            totaloperacionesreestructuradassbd = EXCLUDED.totaloperacionesreestructuradassbd,
            tipoindicadorgeneradordivisassbd = EXCLUDED.tipoindicadorgeneradordivisassbd,
            riesgocambiariodeudor           = EXCLUDED.riesgocambiariodeudor,
            montoingresototaldeudor         = EXCLUDED.montoingresototaldeudor,
            totalcargamensualcsd            = EXCLUDED.totalcargamensualcsd,
            indicadorcsd                    = EXCLUDED.indicadorcsd,
            indicadorcic                    = EXCLUDED.indicadorcic,
            saldomoramayorultmeses1421      = EXCLUDED.saldomoramayorultmeses1421,
            nummesesmoramayor1421           = EXCLUDED.nummesesmoramayor1421,
            saldomoramayorultmeses1516      = EXCLUDED.saldomoramayorultmeses1516,
            nummesesmoramayor1516           = EXCLUDED.nummesesmoramayor1516,
            numdiasatraso1421               = EXCLUDED.numdiasatraso1421,
            numdiasatraso1516               = EXCLUDED.numdiasatraso1516,
            updated_at_utc                  = NOW();

    GET DIAGNOSTICS v_qty = ROW_COUNT;
    pqty       := v_qty;
    psqlcode   := '00000';
    psqlmessage := 'OK';
    RETURN NEXT;
EXCEPTION WHEN OTHERS THEN
    pqty       := 0;
    psqlcode   := SQLSTATE;
    psqlmessage := SQLERRM;
    RETURN NEXT;
END;
$$;
