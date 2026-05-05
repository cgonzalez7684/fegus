-- PROCEDURE: feguslocal.generar_cuotasatrasadas(bigint, varchar, varchar, integer, integer)
--
-- Genera N cuotas atrasadas para una operación, donde N depende de p_dias_morosidad
-- (cantidad ≈ dias_morosidad / 30, máximo 12).
-- Catálogo usado: tipo_cuota.

DROP PROCEDURE IF EXISTS feguslocal.generar_cuotasatrasadas CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_cuotasatrasadas(
    IN pid_load_local bigint,
    IN p_idoperacion varchar,
    IN p_iddeudor varchar,
    IN p_tipopersonadeudor integer,
    IN p_dias_morosidad integer
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_dias_acumulados int;
BEGIN
    v_cantidad := LEAST(GREATEST((p_dias_morosidad / 30)::int, 1), 12);

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            v_dias_acumulados := j * 30 + floor(random() * 15)::int;

            INSERT INTO feguslocal.cuotasatrasadas (
                id_load_local, tipopersonadeudor, iddeudor, idoperacioncredito,
                tipocuota, numerocuotaatrasada, diasatraso,
                montocuotaatrasada, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_tipopersonadeudor::varchar,
                p_iddeudor,
                p_idoperacion,
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                j,
                v_dias_acumulados,
                round((random() * 500000 + 10000)::numeric, 2),
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_cuotasatrasadas] Error cuota % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_cuotasatrasadas] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_cuotasatrasadas(bigint, varchar, varchar, integer, integer) OWNER TO postgres;
