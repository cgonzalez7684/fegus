-- PROCEDURE: feguslocal.generar_garantia_valores(bigint, varchar)
--
-- Genera 1 registro de garantiasvalores.
-- Catálogos: tipo_clasificacion_instrumento, tipo_persona,
--            tipo_asignacion_calificacion. Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_garantia_valores CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_garantia_valores(
    IN pid_load_local bigint,
    IN p_idgarantia varchar
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiasvalores (
        id_load_local, idgarantiavalor, tipoclasificacioninstrumento,
        tipopersona, idemisor, idinstrumento, serieinstrumento, premio,
        codigoisin, tipoasignacioncalificacion, categoriacalificacion,
        codigocalificacionriesgo, codigoempresacalificadora,
        valorfacial, tipomonedavalorfacial, valormercado,
        tipomonedavalormercado, fechaconstitucion, fechavencimiento,
        tipocolateralfinanciero, codigocalificacioninstrumento,
        porcentajeajusterc, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (ARRAY[0,1,2,3,4,5,6,7,8])[floor(random() * 9 + 1)],
        CASE WHEN random() < 0.7 THEN (ARRAY[2,3,4,5,6])[floor(random() * 5 + 1)] ELSE NULL END,
        CASE WHEN random() < 0.7 THEN lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0') ELSE NULL END,
        feguslocal.generar_id_fegus('INSTR','seq_garantia'),
        CASE WHEN random() < 0.5 THEN 'SERIE' || floor(random() * 1000)::text ELSE NULL END,
        CASE WHEN random() < 0.5 THEN round((random() * 9.999999)::numeric, 6) ELSE NULL END,
        'CR' || lpad((trunc(random() * 100000000))::text, 8, '0'),
        (ARRAY[0,1,2])[floor(random() * 3 + 1)],
        CASE WHEN random() < 0.5 THEN (ARRAY[0,1,2,3,4,5,6])[floor(random() * 7 + 1)] ELSE NULL END,
        CASE WHEN random() < 0.5 THEN (ARRAY['AAA','AA+','AA','A+','BBB+','BB','B+'])[floor(random() * 7 + 1)] ELSE NULL END,
        CASE WHEN random() < 0.5 THEN (ARRAY[0,1,2,3])[floor(random() * 4 + 1)] ELSE NULL END,
        round((random() * 5000000)::numeric, 2),
        (ARRAY[1,2])[floor(random() * 2 + 1)],
        round((random() * 5000000)::numeric, 2),
        (ARRAY[1,2])[floor(random() * 2 + 1)],
        (CURRENT_DATE - (random() * 1825)::int),
        CASE WHEN random() < 0.7 THEN (CURRENT_DATE + (random() * 1825)::int) ELSE NULL END,
        floor(random() * 21)::int,
        floor(random() * 30 + 1)::int,
        round((random() * 100)::numeric, 2),
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_valores] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_garantia_valores(bigint, varchar) OWNER TO postgres;
