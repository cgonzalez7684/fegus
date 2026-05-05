-- PROCEDURE: feguslocal.generar_operacionesnoreportadas(bigint, varchar, integer)
--
-- Genera 1 a 2 registros de operacionesnoreportadas para un deudor.
-- Catálogo usado: tipo_motivo_operacion_no_reportada.

DROP PROCEDURE IF EXISTS feguslocal.generar_operacionesnoreportadas CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_operacionesnoreportadas(
    IN pid_load_local bigint,
    IN p_iddeudor varchar,
    IN p_tipopersonadeudor integer
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_idoperacion text;
BEGIN
    v_cantidad := floor(random() * 2 + 1)::int;

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            v_idoperacion := feguslocal.generar_id_fegus('OPNR','seq_operacion');

            INSERT INTO feguslocal.operacionesnoreportadas (
                id_load_local, tipopersona, iddeudor, idoperacion,
                motivoliquidacion, fechaliquidacion,
                saldoprincipalliquidado, saldoproductosliquidado,
                idoperacionnueva, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_tipopersonadeudor::varchar,
                p_iddeudor,
                v_idoperacion,
                ((ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                       21,22,23,24,25,26,27,28,29,30,31,32,33,34,98])[floor(random() * 36 + 1)])::varchar,
                (CURRENT_DATE - (random() * 730)::int),
                round((random() * 5000000)::numeric, 2),
                round((random() * 500000)::numeric, 2),
                CASE WHEN random() < 0.3 THEN feguslocal.generar_id_fegus('OPER','seq_operacion') ELSE NULL END,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_operacionesnoreportadas] Error fila % de %: % | SQLSTATE=% | deudor=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_iddeudor;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_operacionesnoreportadas] Error general: % | SQLSTATE=% | deudor=%',
                     SQLERRM, SQLSTATE, p_iddeudor;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_operacionesnoreportadas(bigint, varchar, integer) OWNER TO postgres;
