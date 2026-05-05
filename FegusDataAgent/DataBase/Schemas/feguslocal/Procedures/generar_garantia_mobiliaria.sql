-- PROCEDURE: feguslocal.generar_garantia_mobiliaria(bigint, varchar)
--
-- Genera 1 registro de garantiasmobiliarias.
-- Asociado a tipogarantia=5 (supuesto SUGEF).
-- Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_garantia_mobiliaria CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_garantia_mobiliaria(
    IN pid_load_local bigint,
    IN p_idgarantia varchar
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiasmobiliarias (
        id_load_local, idgarantiamobiliaria, fechapublicidadgm,
        montogarantiamobiliaria, fechavencimientogm, fechamontoreferencia,
        montoreferencia, tipomonedamontoreferencia, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (CURRENT_DATE - (random() * 730)::int),
        round((random() * 20000000)::numeric, 2),
        (CURRENT_DATE + (random() * 1825)::int),
        (CURRENT_DATE - (random() * 365)::int),
        round((random() * 20000000)::numeric, 2),
        ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_mobiliaria] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_garantia_mobiliaria(bigint, varchar) OWNER TO postgres;
