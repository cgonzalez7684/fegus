-- PROCEDURE: feguslocal.generar_ingresos_deudor(bigint, varchar, integer)
--
-- Genera 1 a 3 registros de ingresodeudores para un deudor.
-- Catálogos usados: tipo_ingreso_deudor (1..19).
-- tipomonedaingreso: 1 ó 2 (CRC/USD por confirmación del usuario).

DROP PROCEDURE IF EXISTS feguslocal.generar_ingresos_deudor CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_ingresos_deudor(
    IN pid_load_local bigint,
    IN p_iddeudor varchar,
    IN p_tipopersonadeudor integer
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_tipos    int[];
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, tipopersonadeudor, iddeudor, tipoingresodeudor, tipomonedaingreso)
    -- Muestrear v_cantidad tipoingresodeudor DISTINTOS. Como dentro de un mismo
    -- iddeudor los tipos serán distintos, la tupla (tipo, moneda) también será única.
    v_tipos := ARRAY(
        SELECT c FROM unnest(ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.ingresodeudores (
                id_load_local, tipopersonadeudor, iddeudor, tipoingresodeudor,
                montoingresodeudor, tipomonedaingreso, fechaverificacioningreso,
                updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_tipopersonadeudor::varchar,
                p_iddeudor,
                v_tipos[j]::varchar,
                round((random() * 10000000 + 100000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                CASE WHEN random() < 0.7 THEN (CURRENT_DATE - (random() * 365)::int) ELSE NULL END,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_ingresos_deudor] Error fila % de %: % | SQLSTATE=% | deudor=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_iddeudor;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_ingresos_deudor] Error general: % | SQLSTATE=% | deudor=%',
                     SQLERRM, SQLSTATE, p_iddeudor;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_ingresos_deudor(bigint, varchar, integer) OWNER TO postgres;
