-- PROCEDURE: feguslocal.generar_naturalezagasto(bigint, varchar)
--
-- Genera 1 a 3 registros de naturalezagasto para una operación. Porcentajes suman 100.
-- Catálogo usado: tipo_naturaleza_gasto.

DROP PROCEDURE IF EXISTS feguslocal.generar_naturalezagasto CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_naturalezagasto(
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

    -- PK: (id_load_local, idoperacioncredito, tiponaturalezagasto)
    -- Muestrear v_cantidad códigos DISTINTOS del catálogo para evitar duplicados.
    v_codigos := ARRAY(
        SELECT c FROM unnest(ARRAY[
            102,104,106,108,110,112,114,116,118,120,125,126,127,190,202,
            203,204,280,281,282,283,284,285,286,290,302,304,306,308,310,
            312,313,314,316,318,320,322,390
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

            INSERT INTO feguslocal.naturalezagasto (
                id_load_local, idoperacioncredito, tiponaturalezagasto,
                porcentajenaturalezagasto, updated_at_utc
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
                RAISE NOTICE '[generar_naturalezagasto] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_naturalezagasto] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_naturalezagasto(bigint, varchar) OWNER TO postgres;
