-- PROCEDURE: feguslocal.generar_garantia_real(bigint, varchar)
--
-- Genera 1 registro de garantiasreales. Si indicadorpolizagarantiareal='S',
-- encadena la generación de la póliza correspondiente en garantiaspolizas.
-- Catálogos: tipo_persona, tipo_bien (para tipobiengarantiareal). Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_garantia_real CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_garantia_real(
    IN pid_load_local bigint,
    IN p_idgarantia varchar
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_indicadorpoliza varchar(1);
    v_tipobiengarantia int;
BEGIN
    v_indicadorpoliza := CASE WHEN random() < 0.40 THEN 'S' ELSE 'N' END;
    v_tipobiengarantia := (ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14])[floor(random() * 14 + 1)];

    INSERT INTO feguslocal.garantiasreales (
        id_load_local, idgarantiareal, tipobiengarantiareal,
        montoultimatasacionterreno, montoultimatasacionnoterreno,
        fechaultimatasaciongarantia, fechaultimoseguimientogarantia,
        tipomonedatasacion, fechaconstruccion, tipopersonatasador,
        idtasador, tipopersonaempresatasadora, idempresatasadora,
        indicadorpolizagarantiareal, tipocolateralreal,
        porcentajerecuperacioncolateralreal, tiempo,
        porcentajefactordescuentotiempo, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        v_tipobiengarantia,
        round((random() * 50000000)::numeric, 2),
        round((random() * 50000000)::numeric, 2),
        (CURRENT_DATE - (random() * 1825)::int),
        (CURRENT_DATE - (random() * 365)::int),
        (ARRAY[1,2])[floor(random() * 2 + 1)],
        CASE WHEN random() < 0.5 THEN (CURRENT_DATE - (random() * 7300)::int) ELSE NULL END,
        (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        CASE WHEN random() < 0.7 THEN (ARRAY[2,3,4,5,6])[floor(random() * 5 + 1)] ELSE NULL END,
        CASE WHEN random() < 0.7 THEN lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0') ELSE NULL END,
        v_indicadorpoliza,
        floor(random() * 21)::int,
        round((random() * 100)::numeric, 2),
        floor(random() * 30)::int,
        round((random() * 100)::numeric, 2),
        CURRENT_DATE
    );

    -- Si tiene póliza, generar la fila correspondiente
    IF v_indicadorpoliza = 'S' THEN
        CALL feguslocal.generar_garantia_poliza(pid_load_local, p_idgarantia, 2, v_tipobiengarantia);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_real] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_garantia_real(bigint, varchar) OWNER TO postgres;
