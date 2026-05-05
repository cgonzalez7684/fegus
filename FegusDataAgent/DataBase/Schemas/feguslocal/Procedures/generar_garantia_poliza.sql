-- PROCEDURE: feguslocal.generar_garantia_poliza(bigint, varchar, integer, integer)
--
-- Genera 1 registro de garantiaspolizas. Se llama desde generar_garantia_real
-- cuando indicadorpolizagarantiareal='S'.
-- Catálogos: tipo_garantia, tipo_bien, tipo_poliza, tipo_persona.

DROP PROCEDURE IF EXISTS feguslocal.generar_garantia_poliza CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_garantia_poliza(
    IN pid_load_local bigint,
    IN p_idgarantia varchar,
    IN p_tipogarantia integer,
    IN p_tipobiengarantia integer
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiaspolizas (
        id_load_local, idgarantia, tipogarantia, tipobiengarantia,
        tipopoliza, montopoliza, fechavencimientopoliza,
        indicadorcoberturaspoliza, tipopersonabeneficiario,
        idbeneficiario, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        p_tipogarantia,
        p_tipobiengarantia,
        (ARRAY[1,2,3,4])[floor(random() * 4 + 1)],
        round((random() * 30000000)::numeric, 2),
        (CURRENT_DATE + (random() * 1095)::int),
        CASE WHEN random() < 0.6 THEN 'S' ELSE 'N' END,
        (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_poliza] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_garantia_poliza(bigint, varchar, integer, integer) OWNER TO postgres;
