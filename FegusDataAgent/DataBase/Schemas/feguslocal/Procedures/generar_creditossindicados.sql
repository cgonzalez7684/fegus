-- PROCEDURE: feguslocal.generar_creditossindicados(bigint, varchar)
--
-- Genera 1 a 2 registros de creditossindicados para una operación.
-- Catálogo usado: tipo_persona.

DROP PROCEDURE IF EXISTS feguslocal.generar_creditossindicados CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_creditossindicados(
    IN pid_load_local bigint,
    IN p_idoperacion varchar
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
BEGIN
    v_cantidad := floor(random() * 2 + 1)::int;

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.creditossindicados (
                id_load_local, idoperacioncredito, tipopersona,
                identidadcreditosindicado, idoperacioncreditoentidadcreditosindicado,
                updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                ((ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)])::varchar,
                lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
                feguslocal.generar_id_fegus('OPER','seq_operacion'),
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_creditossindicados] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_creditossindicados] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_creditossindicados(bigint, varchar) OWNER TO postgres;
