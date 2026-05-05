-- PROCEDURE: feguslocal.generar_garantia_cartacredito(bigint, varchar)
--
-- Genera 1 registro de garantiascartascredito.
-- Catálogos: tipo_mitigador_riesgo, tipo_persona, tipo_asignacion_calificacion.
-- Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_garantia_cartacredito CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_garantia_cartacredito(
    IN pid_load_local bigint,
    IN p_idgarantia varchar
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiascartascredito (
        id_load_local, idgarantiacartacredito, tipomitigadorcartacredito,
        fechaconstitucion, fechavencimiento, tipopersona,
        identidadcartacredito, valornominalgarantia, tipomonedavalornominal,
        tipoasignacioncalificacion, codigocalificacioncategoria,
        factor_y, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
               21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,
               39,40,41])[floor(random() * 41 + 1)],
        (CURRENT_DATE - (random() * 730)::int),
        CASE WHEN random() < 0.8 THEN (CURRENT_DATE + (random() * 730)::int) ELSE NULL END,
        (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        round((random() * 50000000)::numeric, 2),
        (ARRAY[1,2])[floor(random() * 2 + 1)],
        (ARRAY[0,1,2])[floor(random() * 3 + 1)],
        floor(random() * 30 + 1)::int,
        round((random() * 9.99)::numeric, 2),
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_cartacredito] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_garantia_cartacredito(bigint, varchar) OWNER TO postgres;
