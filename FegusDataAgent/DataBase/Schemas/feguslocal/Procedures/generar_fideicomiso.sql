-- PROCEDURE: feguslocal.generar_fideicomiso(bigint, varchar)
--
-- Genera 1 registro de fideicomiso. Asociado a tipogarantia=7 (supuesto SUGEF).
-- Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_fideicomiso CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_fideicomiso(
    IN pid_load_local bigint,
    IN p_idgarantia varchar
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.fideicomiso (
        id_load_local, idfideicomisogarantia, fechaconstitucion,
        fechavencimiento, valornominalfideicomiso,
        tipomonedavalornominalfideicomiso, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (CURRENT_DATE - (random() * 1825)::int),
        (CURRENT_DATE + (random() * 3650)::int),
        round((random() * 100000000)::numeric, 2),
        ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_fideicomiso] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_fideicomiso(bigint, varchar) OWNER TO postgres;
