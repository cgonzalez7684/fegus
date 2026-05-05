-- PROCEDURE: feguslocal.generar_modificacion(bigint, varchar)
--
-- Genera 1 a 2 registros de modificacion para una operación.
-- Catálogo usado: tipo_modificacion_operacion.

DROP PROCEDURE IF EXISTS feguslocal.generar_modificacion CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_modificacion(
    IN pid_load_local bigint,
    IN p_idoperacion varchar
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_tipos    int[];
BEGIN
    v_cantidad := floor(random() * 2 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, tipomodificacion)
    -- Muestrear v_cantidad tipos DISTINTOS para evitar duplicados.
    v_tipos := ARRAY(
        SELECT c FROM unnest(ARRAY[
            0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
            20,21,22,23,24,25,27,28,29
        ]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.modificacion (
                id_load_local, idoperacioncredito, fechamodificacion,
                tipomodificacion, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                (CURRENT_DATE - (random() * 365)::int),
                v_tipos[j]::varchar,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_modificacion] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_modificacion] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_modificacion(bigint, varchar) OWNER TO postgres;
