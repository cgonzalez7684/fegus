-- PROCEDURE: feguslocal.generar_bienesrealizablesnoreportados(bigint, integer)
--
-- Genera p_cantidad registros de bienesrealizablesnoreportados.
-- Catálogos: tipo_bien, tipo_motivo_bien_realizable_no_reportado.

DROP PROCEDURE IF EXISTS feguslocal.generar_bienesrealizablesnoreportados CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_bienesrealizablesnoreportados(
    IN pid_load_local bigint,
    IN p_cantidad integer
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    j int;
BEGIN
    RAISE NOTICE '[generar_bienesrealizablesnoreportados] Generando % registros', p_cantidad;

    FOR j IN 1..p_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.bienesrealizablesnoreportados (
                id_load_local, idbienrealizable, indicadorgarantia,
                idgarantia, idbien, tipobien,
                tipomotivobienrealizablenoreportado, ultimovalorcontable,
                valorrecuperadoneto, idoperacioncreditofinanciamiento
            )
            VALUES (
                pid_load_local,
                feguslocal.generar_id_fegus('BRNR','seq_garantia'),
                CASE WHEN random() < 0.30 THEN 'S' ELSE 'N' END,
                CASE WHEN random() < 0.30
                     THEN feguslocal.generar_id_fegus('GARA','seq_garantia')
                     ELSE 'NA' END,
                feguslocal.generar_id_fegus('BIEN','seq_garantia'),
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14])[floor(random() * 14 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 12 + 1)])::varchar,
                round((random() * 30000000)::numeric, 2),
                round((random() * 25000000)::numeric, 2),
                feguslocal.generar_id_fegus('OPER','seq_operacion')
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_bienesrealizablesnoreportados] Error fila % de %: % | SQLSTATE=%',
                             j, p_cantidad, SQLERRM, SQLSTATE;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_bienesrealizablesnoreportados] Error general: % | SQLSTATE=%',
                     SQLERRM, SQLSTATE;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_bienesrealizablesnoreportados(bigint, integer) OWNER TO postgres;
