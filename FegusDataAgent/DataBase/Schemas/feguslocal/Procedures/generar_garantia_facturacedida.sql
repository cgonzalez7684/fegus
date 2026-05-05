-- PROCEDURE: feguslocal.generar_garantia_facturacedida(bigint, varchar)
--
-- Genera 1 registro de garantiasfacturascedidas.
-- Catálogo usado: tipo_persona. Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_garantia_facturacedida CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_garantia_facturacedida(
    IN pid_load_local bigint,
    IN p_idgarantia varchar
)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiasfacturascedidas (
        id_load_local, idgarantiafacturacedida, fechaconstitucion,
        fechavencimiento, tipopersona, idobligado,
        valornominalgarantia, tipomonedavalornominal,
        porcentajeajusterc, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (CURRENT_DATE - (random() * 365)::int),
        CASE WHEN random() < 0.8 THEN (CURRENT_DATE + (random() * 730)::int) ELSE NULL END,
        (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        round((random() * 10000000)::numeric, 2),
        (ARRAY[1,2])[floor(random() * 2 + 1)],
        round((random() * 100)::numeric, 2),
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_facturacedida] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_garantia_facturacedida(bigint, varchar) OWNER TO postgres;
