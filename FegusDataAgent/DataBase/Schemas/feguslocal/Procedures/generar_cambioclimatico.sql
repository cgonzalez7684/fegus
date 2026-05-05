-- PROCEDURE: feguslocal.generar_cambioclimatico(bigint, varchar)
--
-- Genera 1 registro de cambioclimatico para una operación.
-- Catálogos usados: tipo_tema_cambio_climatico, tipo_subtemas_cambio_climatico,
--                   tipo_actividades_cambio_climatico, tipo_ambito_cambio_climatico,
--                   tipo_fuente_financiamiento, tipo_fondo_financiamiento_cambio_climatico,
--                   tipo_modalidad_fuente_financiamiento.

DROP PROCEDURE IF EXISTS feguslocal.generar_cambioclimatico CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_cambioclimatico(
    IN pid_load_local bigint,
    IN p_idoperacion varchar
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.cambioclimatico (
        id_load_local, idoperacioncredito, tipotema, tiposubtema,
        tipoactividad, tipoambito, tipofuentefinanciamiento, tipofondofinanciamiento,
        saldomontoclimatico, codigomodalidad, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idoperacion,
        ((ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 13 + 1)])::varchar,
        ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,
               24,25,26,27,28,29,30,31,32])[floor(random() * 32 + 1)])::varchar,
        ((ARRAY[1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,50,60,70,80,90,100,
               150,200])[floor(random() * 24 + 1)])::varchar,
        ((ARRAY[0,1,2,3])[floor(random() * 4 + 1)])::varchar,
        ((ARRAY['1','1.1','1.2','2','2.1','2.2','3','3.1','3.2','3.3','3.4',
               '4','4.1','4.2'])[floor(random() * 14 + 1)]),
        ((ARRAY[0,1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,48])[floor(random() * 17 + 1)])::varchar,
        round((random() * 5000000)::numeric, 2),
        ((ARRAY[0,1,2,3])[floor(random() * 4 + 1)])::varchar,
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_cambioclimatico] Error: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_cambioclimatico(bigint, varchar) OWNER TO postgres;
