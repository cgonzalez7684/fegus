-- PROCEDURE: feguslocal.generar_cuentasporcobrarnosasociadas(bigint, varchar, integer)
--
-- Genera 0 a 1 registro de cuentasporcobrarnosasociadas (10% de probabilidad).
-- Catálogos usados: tipo_persona, tipo_dependencia, tipo_catalogo. Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_cuentasporcobrarnosasociadas CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_cuentasporcobrarnosasociadas(
    IN pid_load_local bigint,
    IN p_idoperacion varchar,
    IN p_tipopersonadeudor integer
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF random() >= 0.10 THEN
        RETURN;
    END IF;

    INSERT INTO feguslocal.cuentasporcobrarnosasociadas (
        id_load_local, idoperacioncredito, tipopersonadeudor, idpersona,
        tipomonedamonto, montooriginal, tipocatalogosugef,
        cuentacontablesaldoprincipal, saldoprincipal,
        cuentacontablesaldoproductosporcobrar, saldoproductosporcobrar,
        fecharegistrocontable, fechaexigibilidad, fechavencimiento,
        montoestimacionregistrada, tipodependencia, diasmora, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idoperacion,
        p_tipopersonadeudor::varchar,
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
        round((random() * 5000000)::numeric, 2),
        ((ARRAY[1,2,3,4,5,6,7,8,14,33,34,35,36])[floor(random() * 13 + 1)])::varchar,
        ((ARRAY[13131101,13131102,13231101])[floor(random() * 3 + 1)])::varchar,
        round((random() * 5000000)::numeric, 2),
        ((ARRAY[13831101,13831102])[floor(random() * 2 + 1)])::varchar,
        round((random() * 500000)::numeric, 2),
        (CURRENT_DATE - (random() * 365)::int),
        (CURRENT_DATE + (random() * 365)::int),
        (CURRENT_DATE + (random() * 730)::int),
        round((random() * 100000)::numeric, 2),
        ((ARRAY[1,2,3,4,5,6,7,8,9,10])[floor(random() * 10 + 1)])::varchar,
        floor(random() * 365)::int,
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_cuentasporcobrarnosasociadas] Error: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_cuentasporcobrarnosasociadas(bigint, varchar, integer) OWNER TO postgres;
