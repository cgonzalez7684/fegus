-- PROCEDURE: feguslocal.generar_operacionesbienesrealizables(bigint)
--
-- Genera la tabla puente N:M entre bienes realizables y operaciones de crédito.
-- Toma todos los bienesrealizables del pid_load_local y los vincula a una
-- operación aleatoria existente del mismo pid_load_local.
--
-- No usa catálogos (solo IDs ya generados).

DROP PROCEDURE IF EXISTS feguslocal.generar_operacionesbienesrealizables CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_operacionesbienesrealizables(
    IN pid_load_local bigint
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    cur_bienes CURSOR FOR
        SELECT idbienrealizable
        FROM feguslocal.bienesrealizables
        WHERE id_load_local = pid_load_local;

    v_idbien        text;
    v_idoperacion   text;
    v_iddeudor      text;
    v_tipopersona   text;
    v_count_bienes  int := 0;
    v_count_total   int;
BEGIN
    SELECT COUNT(*) INTO v_count_total
    FROM feguslocal.operacionescredito
    WHERE id_load_local = pid_load_local;

    IF v_count_total = 0 THEN
        RAISE NOTICE '[generar_operacionesbienesrealizables] Sin operaciones para vincular. Skip.';
        RETURN;
    END IF;

    OPEN cur_bienes;
    LOOP
        FETCH cur_bienes INTO v_idbien;
        EXIT WHEN NOT FOUND;

        BEGIN
            -- Selecciona una operación aleatoria del mismo pid_load_local
            SELECT "IdOperacionCredito", "IdDeudor", "TipoPersonaDeudor"::text
            INTO v_idoperacion, v_iddeudor, v_tipopersona
            FROM feguslocal.operacionescredito
            WHERE id_load_local = pid_load_local
            ORDER BY random()
            LIMIT 1;

            INSERT INTO feguslocal.operacionesbienesrealizables (
                id_load_local, idbienrealizable, tipopersonadeudor,
                iddeudor, idoperacioncredito, updated_at_utc
            )
            VALUES (
                pid_load_local,
                v_idbien,
                v_tipopersona,
                v_iddeudor,
                v_idoperacion,
                CURRENT_DATE
            );

            v_count_bienes := v_count_bienes + 1;

        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_operacionesbienesrealizables] Error vinculando bien %: % | SQLSTATE=%',
                             v_idbien, SQLERRM, SQLSTATE;
                RAISE;
        END;
    END LOOP;
    CLOSE cur_bienes;

    RAISE NOTICE '[generar_operacionesbienesrealizables] % vinculaciones creadas', v_count_bienes;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_operacionesbienesrealizables] Error general: % | SQLSTATE=%',
                     SQLERRM, SQLSTATE;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_operacionesbienesrealizables(bigint) OWNER TO postgres;
