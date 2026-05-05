-- PROCEDURE: feguslocal.generar_gravamenes(bigint, varchar, varchar)
--
-- Genera 0 a 2 registros de gravamenes asociados a una garantía.
-- Catálogos: tipo_mitigador_riesgo, tipo_documento_legal, tipo_grado, tipo_persona.
-- Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_gravamenes CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_gravamenes(
    IN pid_load_local bigint,
    IN p_idoperacion varchar,
    IN p_idgarantia varchar
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
BEGIN
    v_cantidad := floor(random() * 3)::int;  -- 0..2

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.gravamenes (
                id_load_local, idoperacioncredito, idgarantia,
                tipomitigador, tipodocumentolegal, tipogradogravamenes,
                tipopersonaacreedor, idacreedor, montogradogravamen,
                tipomonedamonto, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                p_idgarantia,
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                       21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,
                       39,40,41])[floor(random() * 41 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                       21,22,23,24,25,26,27,28,29,30,31,32])[floor(random() * 32 + 1)])::varchar,
                ((ARRAY[1,2,3,4])[floor(random() * 4 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)])::varchar,
                lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
                round((random() * 20000000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_gravamenes] Error fila % de %: % | SQLSTATE=% | idgarantia=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idgarantia;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_gravamenes] Error general: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_gravamenes(bigint, varchar, varchar) OWNER TO postgres;
