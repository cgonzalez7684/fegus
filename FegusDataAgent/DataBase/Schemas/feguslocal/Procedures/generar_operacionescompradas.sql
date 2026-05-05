-- PROCEDURE: feguslocal.generar_operacionescompradas(bigint, varchar, varchar, integer)
--
-- Genera 0 a 1 registro de operacionescompradas (5% de probabilidad).
-- Catálogo usado: tipo_persona.

DROP PROCEDURE IF EXISTS feguslocal.generar_operacionescompradas CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_operacionescompradas(
    IN pid_load_local bigint,
    IN p_idoperacion varchar,
    IN p_iddeudor varchar,
    IN p_tipopersonadeudor integer
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF random() >= 0.05 THEN
        RETURN;
    END IF;

    INSERT INTO feguslocal.operacionescompradas (
        id_load_local, idoperacioncredito, tipopersonaentidadoperacion,
        identidadoperacioncomprada, tipopersonadeudor, iddeudorcomprada,
        idoperacioncreditocomprada, fechadesembolsodeudor, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idoperacion,
        ((ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)])::varchar,
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        p_tipopersonadeudor::varchar,
        p_iddeudor,
        feguslocal.generar_id_fegus('OPERC','seq_operacion'),
        (CURRENT_DATE - (random() * 730)::int),
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_operacionescompradas] Error: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_operacionescompradas(bigint, varchar, varchar, integer) OWNER TO postgres;
