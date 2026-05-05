-- PROCEDURE: feguslocal.generar_garantia_operacion(bigint, varchar, integer, varchar)
--
-- Genera 1 a 3 garantías para una operación. Para cada garantía:
--   1. Inserta fila en garantiasoperacion
--   2. Enruta por tipogarantia al subtipo correspondiente:
--        1 → garantiasfiduciarias
--        2 → garantiasreales      (que a su vez puede generar garantiaspolizas)
--        3 → garantiasvalores
--        4 → garantiascartascredito
--        5 → garantiasmobiliarias  [SUPUESTO SUGEF]
--        6 → garantiasfacturascedidas
--        7 → fideicomiso           [SUPUESTO SUGEF]
--   3. Genera gravámenes asociados.
--
-- Catálogos: tipo_garantia, tipo_persona, tipo_mitigador_riesgo,
--            tipo_documento_legal, tipo_indicador_inscripcion. Moneda: 1 ó 2.

DROP PROCEDURE IF EXISTS feguslocal.generar_garantia_operacion CASCADE;
CREATE OR REPLACE PROCEDURE feguslocal.generar_garantia_operacion(
    IN pid_load_local bigint,
    IN p_iddeudor varchar,
    IN p_tipopersonadeudor integer,
    IN p_idoperacion varchar
)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad     int;
    j              int;
    v_tipogarantia int;
    v_idgarantia   text;
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            -- Selección ponderada: tipos con subtipo (1..7) más probables que 0,8,9
            v_tipogarantia := CASE
                WHEN random() < 0.30 THEN 2  -- reales (más comunes)
                WHEN random() < 0.55 THEN 1  -- fiduciarias
                WHEN random() < 0.70 THEN 3  -- valores
                WHEN random() < 0.80 THEN 4  -- cartas de crédito
                WHEN random() < 0.88 THEN 5  -- mobiliarias
                WHEN random() < 0.94 THEN 6  -- facturas cedidas
                WHEN random() < 0.98 THEN 7  -- fideicomiso
                ELSE (ARRAY[0,8,9])[floor(random() * 3 + 1)]
            END;

            v_idgarantia := feguslocal.generar_id_fegus('GARA','seq_garantia');

            INSERT INTO feguslocal.garantiasoperacion (
                id_load_local, tipopersonadeudor, iddeudor, idoperacioncredito,
                tipogarantia, idgarantia, indicadorformatraspasobien,
                idgarantiatraspaso, tipomitigador, tipodocumentolegal,
                valorajustadogarantia, tipoinscripciongarantia,
                porcentajeresponsabilidadgarantia, valornominalgarantia,
                fechapresentacionregistrogarantia, tipomonedavalornominalgarantia,
                fechaconstituciongarantia, fechavencimientogarantia,
                updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_tipopersonadeudor::varchar,
                p_iddeudor,
                p_idoperacion,
                v_tipogarantia::varchar,
                v_idgarantia,
                CASE WHEN random() < 0.10 THEN 'S' ELSE 'N' END,
                'NA',
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                       21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,
                       39,40,41])[floor(random() * 41 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                       21,22,23,24,25,26,27,28,29,30,31,32])[floor(random() * 32 + 1)])::varchar,
                round((random() * 50000000)::numeric, 2),
                ((ARRAY[0,1,2,3])[floor(random() * 4 + 1)])::varchar,
                round((random() * 100)::numeric, 2),
                round((random() * 50000000)::numeric, 2),
                CASE WHEN random() < 0.7 THEN (CURRENT_DATE - (random() * 365)::int) ELSE NULL END,
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                CASE WHEN random() < 0.7 THEN (CURRENT_DATE - (random() * 365)::int) ELSE NULL END,
                CASE WHEN random() < 0.7 THEN (CURRENT_DATE + (random() * 1825)::int) ELSE NULL END,
                CURRENT_DATE
            );

            -- Router al subtipo correspondiente
            CASE v_tipogarantia
                WHEN 1 THEN
                    CALL feguslocal.generar_garantia_fiduciaria(pid_load_local, v_idgarantia);
                WHEN 2 THEN
                    CALL feguslocal.generar_garantia_real(pid_load_local, v_idgarantia);
                WHEN 3 THEN
                    CALL feguslocal.generar_garantia_valores(pid_load_local, v_idgarantia);
                WHEN 4 THEN
                    CALL feguslocal.generar_garantia_cartacredito(pid_load_local, v_idgarantia);
                WHEN 5 THEN
                    CALL feguslocal.generar_garantia_mobiliaria(pid_load_local, v_idgarantia);
                WHEN 6 THEN
                    CALL feguslocal.generar_garantia_facturacedida(pid_load_local, v_idgarantia);
                WHEN 7 THEN
                    CALL feguslocal.generar_fideicomiso(pid_load_local, v_idgarantia);
                ELSE
                    NULL;  -- 0, 8, 9: sin subtipo
            END CASE;

            -- Gravámenes asociados a esta garantía
            CALL feguslocal.generar_gravamenes(pid_load_local, p_idoperacion, v_idgarantia);

        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_garantia_operacion] Error garantía % de % (tipo=%): % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, v_tipogarantia, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_operacion] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;

ALTER PROCEDURE feguslocal.generar_garantia_operacion(bigint, varchar, integer, varchar) OWNER TO postgres;
