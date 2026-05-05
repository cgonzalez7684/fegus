-- PROCEDURE: feguslocal.generar_origenrecursos(bigint, varchar)
--
-- Genera 1 a 3 registros de origenrecursos para una operación. Porcentajes suman 100.
-- Catálogo usado: tipo_origen_recursos.

DROP PROCEDURE IF EXISTS feguslocal.generar_origenrecursos CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_origenrecursos(
    IN pid_load_local bigint,
    IN p_idoperacion varchar
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad   int;
    j            int;
    v_porcentaje numeric(5,2);
    v_acumulado  numeric(5,2) := 0;
    v_codigos    int[];
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, tipoorigenrecursos)
    -- Muestrear v_cantidad códigos DISTINTOS del catálogo para evitar duplicados.
    v_codigos := ARRAY(
        SELECT c FROM unnest(ARRAY[
            102,104,106,108,110,112,114,116,118,119,120,121,122,123,190,
            201,211,212,213,214,215,216,221,222,223,225,226,301,302,303,
            305,306,401,402,403,405,406,432,433,434,435,501
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

            INSERT INTO feguslocal.origenrecursos (
                id_load_local, idoperacioncredito, tipoorigenrecursos,
                porcentajeorigenrecursos, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                v_codigos[j]::varchar,
                v_porcentaje,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_origenrecursos] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_origenrecursos] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_origenrecursos(bigint, varchar) OWNER TO postgres;
