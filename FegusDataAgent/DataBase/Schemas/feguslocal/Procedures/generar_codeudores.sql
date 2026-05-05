-- PROCEDURE: feguslocal.generar_codeudores(bigint, varchar)
--
-- Genera 1 a 3 codeudores para una operación.
-- Catálogo usado: tipo_persona.

DROP PROCEDURE IF EXISTS feguslocal.generar_codeudores CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_codeudores(
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
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, idcodeudor, tipopersonacodeudor)
    -- Muestrear v_cantidad tipopersonacodeudor DISTINTOS. Aunque idcodeudor sea
    -- aleatorio, asegurar tipopersonacodeudor distinto garantiza tupla única.
    v_tipos := ARRAY(
        SELECT c FROM unnest(ARRAY[1,2,3,4,5,6,13,14,15]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.codeudores (
                id_load_local, idoperacioncredito, tipopersonacodeudor,
                idcodeudor, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                v_tipos[j]::varchar,
                lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_codeudores] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_codeudores] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_codeudores(bigint, varchar) OWNER TO postgres;
