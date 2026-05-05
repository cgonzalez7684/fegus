-- PROCEDURE: feguslocal.generar_garantia_fiduciaria(bigint, varchar)
--
-- Genera 1 registro de garantiasfiduciarias.
-- Catálogo usado: tipo_persona.

DROP PROCEDURE IF EXISTS feguslocal.generar_garantia_fiduciaria CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_garantia_fiduciaria(
    IN pid_load_local bigint,
    IN p_idgarantia varchar
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiasfiduciarias (
        id_load_local, idgarantiafiduciaria, tipopersona, idfiador,
        salarionetofiador, fechaverificacionasalariado, montoavalado,
        porcentajemitigacionfondo, porcentajeestimacionminimofondo,
        updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        round((random() * 5000000 + 300000)::numeric, 2),
        CASE WHEN random() < 0.7 THEN (CURRENT_DATE - (random() * 365)::int) ELSE NULL END,
        round((random() * 50000000)::numeric, 2),
        round((random() * 100)::numeric, 2),
        round((random() * 100)::numeric, 2),
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_fiduciaria] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_garantia_fiduciaria(bigint, varchar) OWNER TO postgres;
