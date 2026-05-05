-- PROCEDURE: feguslocal.generar_actividadeconomica(bigint, varchar)
--
-- Genera 1 a 3 actividades económicas para una operación, con porcentajes que suman 100.
-- Catálogo usado: tipo_actividad_economica.

DROP PROCEDURE IF EXISTS feguslocal.generar_actividadeconomica CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_actividadeconomica(
    IN pid_load_local bigint,
    IN p_idoperacion varchar
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad      int;
    j               int;
    v_porcentaje    numeric(5,2);
    v_acumulado     numeric(5,2) := 0;
    v_codigos       text[];
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, tipoactividadeconomica)
    -- Muestrear v_cantidad códigos DISTINTOS del catálogo para evitar duplicados.
    v_codigos := ARRAY(
        SELECT c FROM unnest(ARRAY[
            'A021101','A021102','D02','F02','G02','I02','J02','M02','S02','Y02',
            'C02','H02','K02','R02','B02','A04','D04','F04','G04','I04'
        ]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            IF j = v_cantidad THEN
                v_porcentaje := round((100 - v_acumulado)::numeric, 2);
            ELSE
                v_porcentaje := round((random() * (100 - v_acumulado) / (v_cantidad - j + 1) + 1)::numeric, 2);
                v_acumulado := v_acumulado + v_porcentaje;
            END IF;

            INSERT INTO feguslocal.actividadeconomica (
                id_load_local, idoperacioncredito, tipoactividadeconomica,
                porcentajeactividadeconomica, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                v_codigos[j],
                v_porcentaje,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_actividadeconomica] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_actividadeconomica] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_actividadeconomica(bigint, varchar) OWNER TO postgres;
