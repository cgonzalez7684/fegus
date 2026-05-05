-- PROCEDURE: feguslocal.generar_bienesrealizables(bigint, integer)
--
-- Genera p_cantidad registros independientes de bienesrealizables.
-- Estos bienes se vinculan posteriormente a operaciones vía
-- generar_operacionesbienesrealizables (puente N:M).
--
-- Catálogos: tipo_adquisicion_bien, tipo_bien, tipo_catalogo, tipo_persona.
-- Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_bienesrealizables CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_bienesrealizables(
    IN pid_load_local bigint,
    IN p_cantidad integer
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    j int;
BEGIN
    RAISE NOTICE '[generar_bienesrealizables] Generando % bienes realizables', p_cantidad;

    FOR j IN 1..p_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.bienesrealizables (
                id_load_local, tipoadquisicionbien, idbienrealizable,
                indicadorgarantia, idgarantia, idbien, tipobien,
                fechaadjudicaciondacionbien, saldoregistrocontable,
                tipomonedasaldoregistrocontable, cuentacatalogosugef,
                tipocatalogosugef, fechaultimatasacionbien,
                montoultimatasacion, tipomonedamontoavaluo,
                tipopersonatasador, idtasador, tipopersonaempresatasadora,
                idempresatasadora, saldocontablecreditocancelado,
                tipomonedasaldocontablecreditocancelado, montoestimacion,
                updated_at_utc
            )
            VALUES (
                pid_load_local,
                ((ARRAY[1,2,3,4,5,6,7])[floor(random() * 7 + 1)])::varchar,
                feguslocal.generar_id_fegus('BR','seq_garantia'),
                CASE WHEN random() < 0.40 THEN 'S' ELSE 'N' END,
                CASE WHEN random() < 0.40
                     THEN feguslocal.generar_id_fegus('GARA','seq_garantia')
                     ELSE 'NA' END,
                feguslocal.generar_id_fegus('BIEN','seq_garantia'),
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14])[floor(random() * 14 + 1)])::varchar,
                (CURRENT_DATE - (random() * 1825)::int),
                round((random() * 50000000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                ((ARRAY['16101100','16101200','16102100','16102200','16201100',
                        '16201200','16301100','16301200'])[floor(random() * 8 + 1)]),
                ((ARRAY[1,2,3,4,5,6,7,8,14,33,34,35,36])[floor(random() * 13 + 1)])::varchar,
                (CURRENT_DATE - (random() * 1825)::int),
                round((random() * 60000000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)])::varchar,
                lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
                ((ARRAY[2,3,4,5,6])[floor(random() * 5 + 1)])::varchar,
                lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
                round((random() * 50000000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                round((random() * 5000000)::numeric, 2),
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_bienesrealizables] Error fila % de %: % | SQLSTATE=%',
                             j, p_cantidad, SQLERRM, SQLSTATE;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_bienesrealizables] Error general: % | SQLSTATE=%',
                     SQLERRM, SQLSTATE;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_bienesrealizables(bigint, integer) OWNER TO postgres;
