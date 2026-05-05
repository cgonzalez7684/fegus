-- PROCEDURE: feguslocal.gerancion_datos_dummy(integer, integer)

-- DROP PROCEDURE IF EXISTS feguslocal.gerancion_datos_dummy(integer, integer);

CREATE OR REPLACE PROCEDURE feguslocal.gerancion_datos_dummy(
	IN p_id_cliente integer,
	IN p_num_registros integer)
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
    i               INT;
    pid_load_local  feguslocal.fe_box_data_load.id_load_local%TYPE;
    pCant_Operaciones int;
    v_count_deudor  int := 0;
    v_count_op      int := 0;

    cur_deudores CURSOR FOR
        SELECT *
        FROM feguslocal.deudores
        WHERE id_load_local = pid_load_local;

    rec feguslocal.deudores_type;

BEGIN
    RAISE NOTICE '[gerancion_datos_dummy] INICIO: cliente=%, num_registros=%',
                 p_id_cliente, p_num_registros;

    -----------------------------------------------------------------
    -- 1. Resolver pid_load_local (caja CREATED activa del cliente)
    -----------------------------------------------------------------
    SELECT COALESCE((
        SELECT b.id_load_local
        FROM feguslocal.fe_box_data_load b
        WHERE b.id_cliente = p_id_cliente
          AND b.state_code = 'CREATED'
          AND b.is_active = 'A'
        ORDER BY b.created_at_utc ASC
        LIMIT 1
        FOR UPDATE SKIP LOCKED
    ), 0)
    INTO pid_load_local;

    -- Override de prueba (igual al procedimiento original).
    pid_load_local := -1;

    RAISE NOTICE '[gerancion_datos_dummy] pid_load_local resuelto=%', pid_load_local;

    -----------------------------------------------------------------
    -- 2. Limpieza de todas las tablas dependientes para este pid_load_local
    -----------------------------------------------------------------
    BEGIN
	    -----------------------------------------------------------------
	    -- NIVEL 1: hojas más profundas (dependen de subtipos o tablas puente)
	    -----------------------------------------------------------------
	    DELETE FROM feguslocal.garantiaspolizas              WHERE id_load_local = pid_load_local;  -- depende de garantiasreales
	    DELETE FROM feguslocal.gravamenes                    WHERE id_load_local = pid_load_local;  -- depende de garantiasoperacion + operacionescredito
	    DELETE FROM feguslocal.operacionesbienesrealizables  WHERE id_load_local = pid_load_local;  -- puente bienes <-> operaciones
	
	    -----------------------------------------------------------------
	    -- NIVEL 2: subtipos de garantía (hijos de garantiasoperacion)
	    -----------------------------------------------------------------
	    DELETE FROM feguslocal.garantiasfiduciarias          WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.garantiasreales               WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.garantiasvalores              WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.garantiascartascredito        WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.garantiasfacturascedidas      WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.garantiasmobiliarias          WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.fideicomiso                   WHERE id_load_local = pid_load_local;
	
	    -----------------------------------------------------------------
	    -- NIVEL 3: cabecera de garantías (hija de operacionescredito)
	    -----------------------------------------------------------------
	    DELETE FROM feguslocal.garantiasoperacion            WHERE id_load_local = pid_load_local;
	
	    -----------------------------------------------------------------
	    -- NIVEL 4: hijos directos de operacionescredito
	    -----------------------------------------------------------------
	    DELETE FROM feguslocal.actividadeconomica            WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.codeudores                    WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.creditossindicados            WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.naturalezagasto               WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.origenrecursos                WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.modificacion                  WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.cambioclimatico               WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.cuotasatrasadas               WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.cuentasxcobrar                WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.cuentasporcobrarnosasociadas  WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.operacionescompradas          WHERE id_load_local = pid_load_local;
	
	    -----------------------------------------------------------------
	    -- NIVEL 5: bienes realizables (independientes; pueden referenciar operaciones por idoperacioncredito)
	    -----------------------------------------------------------------
	    DELETE FROM feguslocal.bienesrealizables             WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.bienesrealizablesnoreportados WHERE id_load_local = pid_load_local;
	
	    -----------------------------------------------------------------
	    -- NIVEL 6: operacionescredito (padre de los Niveles 3 y 4)
	    -----------------------------------------------------------------
	    DELETE FROM feguslocal.operacionescredito            WHERE id_load_local = pid_load_local;
	
	    -----------------------------------------------------------------
	    -- NIVEL 7: hijos directos del deudor
	    -----------------------------------------------------------------
	    DELETE FROM feguslocal.ingresodeudores               WHERE id_load_local = pid_load_local;
	    DELETE FROM feguslocal.operacionesnoreportadas       WHERE id_load_local = pid_load_local;
	
	    -----------------------------------------------------------------
	    -- NIVEL 8: raíz
	    -----------------------------------------------------------------
	    DELETE FROM feguslocal.deudores                      WHERE id_load_local = pid_load_local;
	
	    RAISE NOTICE '[gerancion_datos_dummy] Limpieza completada para pid_load_local=%', pid_load_local;

	EXCEPTION
	    WHEN OTHERS THEN
	        RAISE NOTICE '[gerancion_datos_dummy] Error en limpieza: % | SQLSTATE=%', SQLERRM, SQLSTATE;
	        RAISE;
	END;

    -----------------------------------------------------------------
    -- 3. Insertar p_num_registros deudores
    -----------------------------------------------------------------
    FOR i IN 1..p_num_registros LOOP
        BEGIN
            INSERT INTO feguslocal.deudores (
                id_load_local,
                tipodeudorsfn,
                tipopersonadeudor,
                iddeudor,
                codigosectoreconomico,
                tipocapacidadpago,
                saldototalsegmentacion,
                tipocondicionespecialdeudor,
                fechacalificacionriesgo,
                tipoindicadorgeneradordivisas,
                tipoasignacioncalificacion,
                categoriacalificacion,
                calificacionriesgo,
                codigoempresacalificadora,
                indicadorvinculadoentidad,
                indicadorvinculadogrupofinanciero,
                idgrupointereseconomico,
                tipocomportamientopago,
                tipoactividadeconomicadeudor,
                tipocomportamientopagosbd,
                tipobeneficiariosbd,
                totaloperacionesreestructuradassbd,
                tipoindicadorgeneradordivisassbd,
                riesgocambiariodeudor,
                montoingresototaldeudor,
                totalcargamensualcsd,
                indicadorcsd,
                indicadorcic,
                saldomoramayorultmeses1421,
                nummesesmoramayor1421,
                saldomoramayorultmeses1516,
                nummesesmoramayor1516,
                numdiasatraso1421,
                numdiasatraso1516,
                updated_at_utc
            )
            VALUES (
                pid_load_local,

                -- tipodeudorsfn (catálogo: 1..12)
                CASE
                    WHEN random() < 0.4 THEN 1
                    WHEN random() < 0.7 THEN 4
                    WHEN random() < 0.85 THEN 5
                    WHEN random() < 0.95 THEN 6
                    ELSE (ARRAY[2,3,7,8,9,10,11,12])[floor(random()*8+1)]
                END,

                -- tipopersonadeudor (catálogo: 1,2,3,4,5,6,13,14,15)
                CASE
                    WHEN random() < 0.5 THEN 1
                    WHEN random() < 0.8 THEN 2
                    ELSE (ARRAY[3,4,5,6,13,14,15])[floor(random()*7+1)]
                END,

                -- iddeudor: secuencia para garantizar unicidad ante PK (id_load_local, tipopersonadeudor, iddeudor)
                lpad(nextval('feguslocal.seq_deudor')::text, 9, '0'),

                -- codigosectoreconomico (catálogo sector_economico, 34 valores)
                (ARRAY[102,104,106,108,110,112,114,116,118,120,122,124,128,140,142,
                       144,146,150,202,204,206,208,210,302,304,306,402,404,406,408,
                       410,412,902,904])[floor(random()*34+1)],

                -- tipocapacidadpago (catálogo: 1,2,3,4)
                CASE
                    WHEN random() < 0.4 THEN 2
                    WHEN random() < 0.7 THEN 3
                    ELSE (ARRAY[1,4])[floor(random()*2+1)]
                END,

                round((random()*1000000)::numeric, 2),

                -- tipocondicionespecialdeudor (catálogo: 1,4,5)
                CASE
                    WHEN random() < 0.7 THEN NULL
                    WHEN random() < 0.85 THEN 1
                    WHEN random() < 0.95 THEN 4
                    ELSE 5
                END,

                (CURRENT_DATE - (random()*1825)::int)::text,

                -- tipoindicadorgeneradordivisas (catálogo: 0..8)
                CASE
                    WHEN random() < 0.7 THEN 0
                    ELSE (ARRAY[1,2,3,4,5,6,7,8])[floor(random()*8+1)]
                END,

                -- tipoasignacioncalificacion (catálogo: 0,1,2)
                CASE
                    WHEN random() < 0.6 THEN 1
                    WHEN random() < 0.85 THEN 2
                    ELSE 0
                END,

                NULL,                -- categoriacalificacion (confirmado: NULL)
                NULL,                -- calificacionriesgo (confirmado: NULL)
                NULL,                -- codigoempresacalificadora (confirmado: NULL)

                CASE
                    WHEN random() < 0.6 THEN NULL
                    WHEN random() < 0.85 THEN 'N'
                    ELSE 'V'
                END,

                CASE
                    WHEN random() < 0.6 THEN NULL
                    WHEN random() < 0.8 THEN 'N'
                    WHEN random() < 0.9 THEN 'V'
                    ELSE 'F'
                END,

                NULL,

                -- tipocomportamientopago (catálogo: 0,1,2,3)
                CASE
                    WHEN random() < 0.5 THEN 1
                    WHEN random() < 0.8 THEN 2
                    ELSE (ARRAY[0,3])[floor(random()*2+1)]
                END,

                -- tipoactividadeconomicadeudor (muestra del catálogo extenso)
                (ARRAY['A021101','A021102','D02','F02','G02','I02','J02','M02','S02','Y02',
                       'C02','H02','K02','R02','B02'])[floor(random()*15+1)],

                -- tipocomportamientopagosbd (catálogo: 0,1,2,3)
                CASE
                    WHEN random() < 0.6 THEN 0
                    ELSE (ARRAY[1,2,3])[floor(random()*3+1)]
                END,

                -- tipobeneficiariosbd (catálogo: 0..20)
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20])[floor(random()*21+1)],

                floor(random()*21)::int,

                -- tipoindicadorgeneradordivisassbd (catálogo: 0..9)
                (ARRAY[0,1,2,3,4,5,6,7,8,9])[floor(random()*10+1)],

                -- riesgocambiariodeudor (catálogo: 0,1,2)
                CASE
                    WHEN random() < 0.7 THEN NULL
                    ELSE (ARRAY[0,1,2])[floor(random()*3+1)]
                END,

                round((random()*50000000+500000)::numeric, 2),
                round((random()*5000000)::numeric, 2),
                CASE WHEN random() < 0.7 THEN 0 ELSE 1 END,
                CASE WHEN random() < 0.5 THEN '0' ELSE '1' END,
                round((random()*10000000)::numeric, 2),
                floor(random()*13)::int,
                round((random()*10000000)::numeric, 2),
                floor(random()*13)::int,
                floor(random()*366)::int,
                floor(random()*366)::int,

                CURRENT_DATE
            );
            v_count_deudor := v_count_deudor + 1;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[gerancion_datos_dummy] Error insertando deudor #%: % | SQLSTATE=%',
                             i, SQLERRM, SQLSTATE;
                RAISE;
        END;
    END LOOP;

    RAISE NOTICE '[gerancion_datos_dummy] % deudores insertados', v_count_deudor;

    -----------------------------------------------------------------
    -- 4. Cursor sobre deudores: generar dependientes por deudor
    -----------------------------------------------------------------
    OPEN cur_deudores;
    LOOP
        FETCH cur_deudores INTO rec;
        EXIT WHEN NOT FOUND;

        BEGIN
            CALL feguslocal.generar_ingresos_deudor(
                pid_load_local, rec.iddeudor, rec.tipopersonadeudor::int);

            IF random() < 0.05 THEN
                CALL feguslocal.generar_operacionesnoreportadas(
                    pid_load_local, rec.iddeudor, rec.tipopersonadeudor::int);
            END IF;

            pCant_Operaciones := FLOOR(RANDOM() * 5 + 1)::int;
            CALL feguslocal.generar_operaciones_deudor(
                pid_load_local, rec, pCant_Operaciones);

            v_count_op := v_count_op + pCant_Operaciones;
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[gerancion_datos_dummy] Error procesando deudor %: % | SQLSTATE=%',
                             rec.iddeudor, SQLERRM, SQLSTATE;
                RAISE;
        END;
    END LOOP;
    CLOSE cur_deudores;

    RAISE NOTICE '[gerancion_datos_dummy] % operaciones generadas (estimado)', v_count_op;

    -----------------------------------------------------------------
    -- 5. Bienes realizables (independientes del deudor)
    -----------------------------------------------------------------
    BEGIN
        CALL feguslocal.generar_bienesrealizables(pid_load_local, GREATEST(p_num_registros / 5, 1));
        CALL feguslocal.generar_operacionesbienesrealizables(pid_load_local);
        CALL feguslocal.generar_bienesrealizablesnoreportados(pid_load_local, GREATEST(p_num_registros / 10, 1));
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE '[gerancion_datos_dummy] Error en bienes realizables: % | SQLSTATE=%',
                         SQLERRM, SQLSTATE;
            RAISE;
    END;

    RAISE NOTICE '[gerancion_datos_dummy] FIN exitoso. Deudores=%, Operaciones=%',
                 v_count_deudor, v_count_op;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[gerancion_datos_dummy] Error general: % | SQLSTATE=%',
                     SQLERRM, SQLSTATE;
        RAISE;
END;
$BODY$;
ALTER PROCEDURE feguslocal.gerancion_datos_dummy(integer, integer)
    OWNER TO postgres;
