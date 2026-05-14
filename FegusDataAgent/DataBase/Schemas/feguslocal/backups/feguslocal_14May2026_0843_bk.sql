--
-- PostgreSQL database dump
--

\restrict IK1FtjuXtaRLlBcUvb7TPJqSAmKu2KarkayQnMQdKHBTLoyLC31cJNJBJfUsSRS

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6

-- Started on 2026-05-14 08:40:16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 10 (class 2615 OID 73947)
-- Name: feguslocal; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA feguslocal;


ALTER SCHEMA feguslocal OWNER TO postgres;

--
-- TOC entry 1373 (class 1247 OID 74292)
-- Name: deudores_type; Type: TYPE; Schema: feguslocal; Owner: postgres
--

CREATE TYPE feguslocal.deudores_type AS (
	id_load_local bigint,
	tipodeudorsfn integer,
	tipopersonadeudor numeric,
	iddeudor character varying(30),
	codigosectoreconomico numeric,
	tipocapacidadpago integer,
	saldototalsegmentacion numeric,
	tipocondicionespecialdeudor integer,
	fechacalificacionriesgo text,
	tipoindicadorgeneradordivisas integer,
	tipoasignacioncalificacion integer,
	categoriacalificacion numeric,
	calificacionriesgo text,
	codigoempresacalificadora numeric,
	indicadorvinculadoentidad character varying,
	indicadorvinculadogrupofinanciero character varying,
	idgrupointereseconomico numeric,
	tipocomportamientopago integer,
	tipoactividadeconomicadeudor character varying(14),
	tipocomportamientopagosbd integer,
	tipobeneficiariosbd integer,
	totaloperacionesreestructuradassbd integer,
	tipoindicadorgeneradordivisassbd integer,
	riesgocambiariodeudor integer,
	montoingresototaldeudor numeric,
	totalcargamensualcsd numeric,
	indicadorcsd numeric,
	indicadorcic character varying(1),
	saldomoramayorultmeses1421 numeric,
	nummesesmoramayor1421 integer,
	saldomoramayorultmeses1516 numeric,
	nummesesmoramayor1516 integer,
	numdiasatraso1421 integer,
	numdiasatraso1516 integer,
	created_at_utc timestamp without time zone,
	updated_at_utc timestamp without time zone
);


ALTER TYPE feguslocal.deudores_type OWNER TO postgres;

--
-- TOC entry 514 (class 1255 OID 90387)
-- Name: fn_box_data_load_insert(integer, bigint, character varying, character varying, timestamp without time zone); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.fn_box_data_load_insert(p_id_cliente integer, p_id_load bigint, p_state_code character varying, p_is_active character varying, p_asofdate timestamp without time zone) RETURNS TABLE(pidload bigint, psqlcode text, psqlmessage text, pqty integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_rowcount integer := 0;
BEGIN

    -- Inicializar valores de salida
    pIdLoad     := NULL;
    pSqlCode    := 0;
    pSqlMessage := NULL;
    pQty        := 0;

    -- Insert con RETURNING
    INSERT INTO feguslocal.fe_box_data_load
    (
        id_cliente,
		id_load,
        state_code,
        is_active,
        asofdate
    )
    VALUES
    (
        p_id_cliente,
		p_id_load,
        p_state_code,
        p_is_active,
        p_asofdate
    )
    RETURNING id_load_local INTO pIdLoad;

    -- Obtener filas afectadas
    GET DIAGNOSTICS v_rowcount = ROW_COUNT;
    pQty := v_rowcount;

    RETURN NEXT;

EXCEPTION
    WHEN OTHERS THEN
        pIdLoad     := NULL;
        pSqlCode    := SQLSTATE;
        pSqlMessage := SQLERRM;
        pQty        := 0;

        RETURN NEXT;
END;
$$;


ALTER FUNCTION feguslocal.fn_box_data_load_insert(p_id_cliente integer, p_id_load bigint, p_state_code character varying, p_is_active character varying, p_asofdate timestamp without time zone) OWNER TO postgres;

--
-- TOC entry 461 (class 1255 OID 123214)
-- Name: generar_actividadeconomica(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_actividadeconomica(IN pid_load_local bigint, IN p_idoperacion character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad      int;
    j               int;
    v_porcentaje    numeric(5,2);
    v_acumulado     numeric(5,2) := 0;
    v_codigos       text[];
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, tipoactividadeconomica)
    -- Muestrear v_cantidad códigos DISTINTOS del catálogo para evitar duplicados.
    v_codigos := ARRAY(
        SELECT c FROM unnest(ARRAY[
            'A021101','A021102','D02','F02','G02','I02','J02','M02','S02','Y02',
            'C02','H02','K02','R02','B02','A04','D04','F04','G04','I04'
        ]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            IF j = v_cantidad THEN
                v_porcentaje := round((100 - v_acumulado)::numeric, 2);
            ELSE
                v_porcentaje := round((random() * (100 - v_acumulado) / (v_cantidad - j + 1) + 1)::numeric, 2);
                v_acumulado := v_acumulado + v_porcentaje;
            END IF;

            INSERT INTO feguslocal.actividadeconomica (
                id_load_local, idoperacioncredito, tipoactividadeconomica,
                porcentajeactividadeconomica, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                v_codigos[j],
                v_porcentaje,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_actividadeconomica] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_actividadeconomica] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_actividadeconomica(IN pid_load_local bigint, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 492 (class 1255 OID 123187)
-- Name: generar_bienesrealizables(bigint, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_bienesrealizables(IN pid_load_local bigint, IN p_cantidad integer)
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


ALTER PROCEDURE feguslocal.generar_bienesrealizables(IN pid_load_local bigint, IN p_cantidad integer) OWNER TO postgres;

--
-- TOC entry 496 (class 1255 OID 123188)
-- Name: generar_bienesrealizablesnoreportados(bigint, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_bienesrealizablesnoreportados(IN pid_load_local bigint, IN p_cantidad integer)
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


ALTER PROCEDURE feguslocal.generar_bienesrealizablesnoreportados(IN pid_load_local bigint, IN p_cantidad integer) OWNER TO postgres;

--
-- TOC entry 460 (class 1255 OID 123174)
-- Name: generar_cambioclimatico(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_cambioclimatico(IN pid_load_local bigint, IN p_idoperacion character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.cambioclimatico (
        id_load_local, idoperacioncredito, tipotema, tiposubtema,
        tipoactividad, tipoambito, tipofuentefinanciamiento, tipofondofinanciamiento,
        saldomontoclimatico, codigomodalidad, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idoperacion,
        ((ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 13 + 1)])::varchar,
        ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,
               24,25,26,27,28,29,30,31,32])[floor(random() * 32 + 1)])::varchar,
        ((ARRAY[1,2,3,4,5,6,7,8,9,10,15,20,25,30,35,40,50,60,70,80,90,100,
               150,200])[floor(random() * 24 + 1)])::varchar,
        ((ARRAY[0,1,2,3])[floor(random() * 4 + 1)])::varchar,
        ((ARRAY['1','1.1','1.2','2','2.1','2.2','3','3.1','3.2','3.3','3.4',
               '4','4.1','4.2'])[floor(random() * 14 + 1)]),
        ((ARRAY[0,1,2,3,4,5,6,7,8,9,10,15,20,25,30,40,48])[floor(random() * 17 + 1)])::varchar,
        round((random() * 5000000)::numeric, 2),
        ((ARRAY[0,1,2,3])[floor(random() * 4 + 1)])::varchar,
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_cambioclimatico] Error: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_cambioclimatico(IN pid_load_local bigint, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 509 (class 1255 OID 123209)
-- Name: generar_codeudores(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_codeudores(IN pid_load_local bigint, IN p_idoperacion character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_tipos    int[];
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, idcodeudor, tipopersonacodeudor)
    -- Muestrear v_cantidad tipopersonacodeudor DISTINTOS. Aunque idcodeudor sea
    -- aleatorio, asegurar tipopersonacodeudor distinto garantiza tupla única.
    v_tipos := ARRAY(
        SELECT c FROM unnest(ARRAY[1,2,3,4,5,6,13,14,15]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.codeudores (
                id_load_local, idoperacioncredito, tipopersonacodeudor,
                idcodeudor, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                v_tipos[j]::varchar,
                lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_codeudores] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_codeudores] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_codeudores(IN pid_load_local bigint, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 518 (class 1255 OID 123170)
-- Name: generar_creditossindicados(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_creditossindicados(IN pid_load_local bigint, IN p_idoperacion character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
BEGIN
    v_cantidad := floor(random() * 2 + 1)::int;

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.creditossindicados (
                id_load_local, idoperacioncredito, tipopersona,
                identidadcreditosindicado, idoperacioncreditoentidadcreditosindicado,
                updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                ((ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)])::varchar,
                lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
                feguslocal.generar_id_fegus('OPER','seq_operacion'),
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_creditossindicados] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_creditossindicados] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_creditossindicados(IN pid_load_local bigint, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 472 (class 1255 OID 123177)
-- Name: generar_cuentasporcobrarnosasociadas(bigint, character varying, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_cuentasporcobrarnosasociadas(IN pid_load_local bigint, IN p_idoperacion character varying, IN p_tipopersonadeudor integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF random() >= 0.10 THEN
        RETURN;
    END IF;

    INSERT INTO feguslocal.cuentasporcobrarnosasociadas (
        id_load_local, idoperacioncredito, tipopersonadeudor, idpersona,
        tipomonedamonto, montooriginal, tipocatalogosugef,
        cuentacontablesaldoprincipal, saldoprincipal,
        cuentacontablesaldoproductosporcobrar, saldoproductosporcobrar,
        fecharegistrocontable, fechaexigibilidad, fechavencimiento,
        montoestimacionregistrada, tipodependencia, diasmora, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idoperacion,
        p_tipopersonadeudor::varchar,
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
        round((random() * 5000000)::numeric, 2),
        ((ARRAY[1,2,3,4,5,6,7,8,14,33,34,35,36])[floor(random() * 13 + 1)])::varchar,
        ((ARRAY[13131101,13131102,13231101])[floor(random() * 3 + 1)])::varchar,
        round((random() * 5000000)::numeric, 2),
        ((ARRAY[13831101,13831102])[floor(random() * 2 + 1)])::varchar,
        round((random() * 500000)::numeric, 2),
        (CURRENT_DATE - (random() * 365)::int),
        (CURRENT_DATE + (random() * 365)::int),
        (CURRENT_DATE + (random() * 730)::int),
        round((random() * 100000)::numeric, 2),
        ((ARRAY[1,2,3,4,5,6,7,8,9,10])[floor(random() * 10 + 1)])::varchar,
        floor(random() * 365)::int,
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_cuentasporcobrarnosasociadas] Error: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_cuentasporcobrarnosasociadas(IN pid_load_local bigint, IN p_idoperacion character varying, IN p_tipopersonadeudor integer) OWNER TO postgres;

--
-- TOC entry 535 (class 1255 OID 123176)
-- Name: generar_cuentasxcobrar(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_cuentasxcobrar(IN pid_load_local bigint, IN p_idoperacion character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
BEGIN
    v_cantidad := floor(random() * 3)::int;  -- 0..2

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.cuentasxcobrar (
                id_load_local, idoperacioncredito, idcuentacobrarasociada,
                cuentacontablecuentacobrarasociada, tipocatalogosugef,
                saldocuentacobrarasociada, tipomonedacuentacobrarasociada,
                diasatrasocuentacobrarasociada, fecharegistrocuentacobrarasociada,
                fechavencimientocuentacobrarasociada, concepto, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                feguslocal.generar_id_fegus('CXC','seq_operacion'),
                ((ARRAY[13831101,13832134,13831110,13831102,13831210,
                       13831103])[floor(random() * 6 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6,7,8,14,33,34,35,36])[floor(random() * 13 + 1)])::varchar,
                round((random() * 1000000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                floor(random() * 365)::int,
                (CURRENT_DATE - (random() * 365)::int),
                (CURRENT_DATE + (random() * 730)::int),
                'Concepto generado para test ' || j::text,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_cuentasxcobrar] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_cuentasxcobrar] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_cuentasxcobrar(IN pid_load_local bigint, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 481 (class 1255 OID 123175)
-- Name: generar_cuotasatrasadas(bigint, character varying, character varying, integer, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_cuotasatrasadas(IN pid_load_local bigint, IN p_idoperacion character varying, IN p_iddeudor character varying, IN p_tipopersonadeudor integer, IN p_dias_morosidad integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_dias_acumulados int;
BEGIN
    v_cantidad := LEAST(GREATEST((p_dias_morosidad / 30)::int, 1), 12);

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            v_dias_acumulados := j * 30 + floor(random() * 15)::int;

            INSERT INTO feguslocal.cuotasatrasadas (
                id_load_local, tipopersonadeudor, iddeudor, idoperacioncredito,
                tipocuota, numerocuotaatrasada, diasatraso,
                montocuotaatrasada, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_tipopersonadeudor::varchar,
                p_iddeudor,
                p_idoperacion,
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                j,
                v_dias_acumulados,
                round((random() * 500000 + 10000)::numeric, 2),
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_cuotasatrasadas] Error cuota % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_cuotasatrasadas] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_cuotasatrasadas(IN pid_load_local bigint, IN p_idoperacion character varying, IN p_iddeudor character varying, IN p_tipopersonadeudor integer, IN p_dias_morosidad integer) OWNER TO postgres;

--
-- TOC entry 517 (class 1255 OID 123184)
-- Name: generar_fideicomiso(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_fideicomiso(IN pid_load_local bigint, IN p_idgarantia character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.fideicomiso (
        id_load_local, idfideicomisogarantia, fechaconstitucion,
        fechavencimiento, valornominalfideicomiso,
        tipomonedavalornominalfideicomiso, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (CURRENT_DATE - (random() * 1825)::int),
        (CURRENT_DATE + (random() * 3650)::int),
        round((random() * 100000000)::numeric, 2),
        ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_fideicomiso] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_fideicomiso(IN pid_load_local bigint, IN p_idgarantia character varying) OWNER TO postgres;

--
-- TOC entry 488 (class 1255 OID 123181)
-- Name: generar_garantia_cartacredito(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_garantia_cartacredito(IN pid_load_local bigint, IN p_idgarantia character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiascartascredito (
        id_load_local, idgarantiacartacredito, tipomitigadorcartacredito,
        fechaconstitucion, fechavencimiento, tipopersona,
        identidadcartacredito, valornominalgarantia, tipomonedavalornominal,
        tipoasignacioncalificacion, codigocalificacioncategoria,
        factor_y, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
               21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,
               39,40,41])[floor(random() * 41 + 1)],
        (CURRENT_DATE - (random() * 730)::int),
        CASE WHEN random() < 0.8 THEN (CURRENT_DATE + (random() * 730)::int) ELSE NULL END,
        (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],
        lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
        round((random() * 50000000)::numeric, 2),
        (ARRAY[1,2])[floor(random() * 2 + 1)],
        (ARRAY[0,1,2])[floor(random() * 3 + 1)],
        floor(random() * 30 + 1)::int,
        round((random() * 9.99)::numeric, 2),
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_cartacredito] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_garantia_cartacredito(IN pid_load_local bigint, IN p_idgarantia character varying) OWNER TO postgres;

--
-- TOC entry 474 (class 1255 OID 123182)
-- Name: generar_garantia_facturacedida(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_garantia_facturacedida(IN pid_load_local bigint, IN p_idgarantia character varying)
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


ALTER PROCEDURE feguslocal.generar_garantia_facturacedida(IN pid_load_local bigint, IN p_idgarantia character varying) OWNER TO postgres;

--
-- TOC entry 491 (class 1255 OID 123179)
-- Name: generar_garantia_fiduciaria(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_garantia_fiduciaria(IN pid_load_local bigint, IN p_idgarantia character varying)
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


ALTER PROCEDURE feguslocal.generar_garantia_fiduciaria(IN pid_load_local bigint, IN p_idgarantia character varying) OWNER TO postgres;

--
-- TOC entry 530 (class 1255 OID 123183)
-- Name: generar_garantia_mobiliaria(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_garantia_mobiliaria(IN pid_load_local bigint, IN p_idgarantia character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiasmobiliarias (
        id_load_local, idgarantiamobiliaria, fechapublicidadgm,
        montogarantiamobiliaria, fechavencimientogm, fechamontoreferencia,
        montoreferencia, tipomonedamontoreferencia, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (CURRENT_DATE - (random() * 730)::int),
        round((random() * 20000000)::numeric, 2),
        (CURRENT_DATE + (random() * 1825)::int),
        (CURRENT_DATE - (random() * 365)::int),
        round((random() * 20000000)::numeric, 2),
        ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_mobiliaria] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_garantia_mobiliaria(IN pid_load_local bigint, IN p_idgarantia character varying) OWNER TO postgres;

--
-- TOC entry 522 (class 1255 OID 123191)
-- Name: generar_garantia_operacion(bigint, character varying, integer, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_garantia_operacion(IN pid_load_local bigint, IN p_iddeudor character varying, IN p_tipopersonadeudor integer, IN p_idoperacion character varying)
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


ALTER PROCEDURE feguslocal.generar_garantia_operacion(IN pid_load_local bigint, IN p_iddeudor character varying, IN p_tipopersonadeudor integer, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 506 (class 1255 OID 123185)
-- Name: generar_garantia_poliza(bigint, character varying, integer, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_garantia_poliza(IN pid_load_local bigint, IN p_idgarantia character varying, IN p_tipogarantia integer, IN p_tipobiengarantia integer)
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


ALTER PROCEDURE feguslocal.generar_garantia_poliza(IN pid_load_local bigint, IN p_idgarantia character varying, IN p_tipogarantia integer, IN p_tipobiengarantia integer) OWNER TO postgres;

--
-- TOC entry 476 (class 1255 OID 123190)
-- Name: generar_garantia_real(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_garantia_real(IN pid_load_local bigint, IN p_idgarantia character varying)
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


ALTER PROCEDURE feguslocal.generar_garantia_real(IN pid_load_local bigint, IN p_idgarantia character varying) OWNER TO postgres;

--
-- TOC entry 524 (class 1255 OID 123180)
-- Name: generar_garantia_valores(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_garantia_valores(IN pid_load_local bigint, IN p_idgarantia character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO feguslocal.garantiasvalores (
        id_load_local, idgarantiavalor, tipoclasificacioninstrumento,
        tipopersona, idemisor, idinstrumento, serieinstrumento, premio,
        codigoisin, tipoasignacioncalificacion, categoriacalificacion,
        codigocalificacionriesgo, codigoempresacalificadora,
        valorfacial, tipomonedavalorfacial, valormercado,
        tipomonedavalormercado, fechaconstitucion, fechavencimiento,
        tipocolateralfinanciero, codigocalificacioninstrumento,
        porcentajeajusterc, updated_at_utc
    )
    VALUES (
        pid_load_local,
        p_idgarantia,
        (ARRAY[0,1,2,3,4,5,6,7,8])[floor(random() * 9 + 1)],
        CASE WHEN random() < 0.7 THEN (ARRAY[2,3,4,5,6])[floor(random() * 5 + 1)] ELSE NULL END,
        CASE WHEN random() < 0.7 THEN lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0') ELSE NULL END,
        feguslocal.generar_id_fegus('INSTR','seq_garantia'),
        CASE WHEN random() < 0.5 THEN 'SERIE' || floor(random() * 1000)::text ELSE NULL END,
        CASE WHEN random() < 0.5 THEN round((random() * 9.999999)::numeric, 6) ELSE NULL END,
        'CR' || lpad((trunc(random() * 100000000))::text, 8, '0'),
        (ARRAY[0,1,2])[floor(random() * 3 + 1)],
        CASE WHEN random() < 0.5 THEN (ARRAY[0,1,2,3,4,5,6])[floor(random() * 7 + 1)] ELSE NULL END,
        CASE WHEN random() < 0.5 THEN (ARRAY['AAA','AA+','AA','A+','BBB+','BB','B+'])[floor(random() * 7 + 1)] ELSE NULL END,
        CASE WHEN random() < 0.5 THEN (ARRAY[0,1,2,3])[floor(random() * 4 + 1)] ELSE NULL END,
        round((random() * 5000000)::numeric, 2),
        (ARRAY[1,2])[floor(random() * 2 + 1)],
        round((random() * 5000000)::numeric, 2),
        (ARRAY[1,2])[floor(random() * 2 + 1)],
        (CURRENT_DATE - (random() * 1825)::int),
        CASE WHEN random() < 0.7 THEN (CURRENT_DATE + (random() * 1825)::int) ELSE NULL END,
        floor(random() * 21)::int,
        floor(random() * 30 + 1)::int,
        round((random() * 100)::numeric, 2),
        CURRENT_DATE
    );

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_garantia_valores] Error: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_garantia_valores(IN pid_load_local bigint, IN p_idgarantia character varying) OWNER TO postgres;

--
-- TOC entry 512 (class 1255 OID 123186)
-- Name: generar_gravamenes(bigint, character varying, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_gravamenes(IN pid_load_local bigint, IN p_idoperacion character varying, IN p_idgarantia character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
BEGIN
    v_cantidad := floor(random() * 3)::int;  -- 0..2

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.gravamenes (
                id_load_local, idoperacioncredito, idgarantia,
                tipomitigador, tipodocumentolegal, tipogradogravamenes,
                tipopersonaacreedor, idacreedor, montogradogravamen,
                tipomonedamonto, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                p_idgarantia,
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                       21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,
                       39,40,41])[floor(random() * 41 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                       21,22,23,24,25,26,27,28,29,30,31,32])[floor(random() * 32 + 1)])::varchar,
                ((ARRAY[1,2,3,4])[floor(random() * 4 + 1)])::varchar,
                ((ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)])::varchar,
                lpad((trunc(random() * 900000000) + 100000000)::text, 9, '0'),
                round((random() * 20000000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_gravamenes] Error fila % de %: % | SQLSTATE=% | idgarantia=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idgarantia;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_gravamenes] Error general: % | SQLSTATE=% | idgarantia=%',
                     SQLERRM, SQLSTATE, p_idgarantia;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_gravamenes(IN pid_load_local bigint, IN p_idoperacion character varying, IN p_idgarantia character varying) OWNER TO postgres;

--
-- TOC entry 521 (class 1255 OID 139490)
-- Name: generar_id_fegus(text, text, integer); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.generar_id_fegus(p_prefijo text, p_secuencia text, p_longitud integer DEFAULT 6) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_next bigint;
    v_sql text;
BEGIN
    -- Construcci├│n din├ímica de nextval
    v_sql := format('SELECT nextval(''feguslocal.%I'')', p_secuencia);
    
    EXECUTE v_sql INTO v_next;

    -- GREATEST(...) prevents LPAD from truncating when the sequence value exceeds p_longitud digits.
    RETURN p_prefijo || LPAD(v_next::text, GREATEST(p_longitud, LENGTH(v_next::text)), '0');
END;
$$;


ALTER FUNCTION feguslocal.generar_id_fegus(p_prefijo text, p_secuencia text, p_longitud integer) OWNER TO postgres;

--
-- TOC entry 528 (class 1255 OID 74297)
-- Name: generar_id_operacion(integer); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.generar_id_operacion(longitud integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    caracteres text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    salida text := '';
BEGIN
    FOR i IN 1..longitud LOOP
        salida := salida || substr(caracteres, (random()*length(caracteres)+1)::int, 1);
    END LOOP;

    RETURN salida;
END 
$$;


ALTER FUNCTION feguslocal.generar_id_operacion(longitud integer) OWNER TO postgres;

--
-- TOC entry 510 (class 1255 OID 123211)
-- Name: generar_ingresos_deudor(bigint, character varying, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_ingresos_deudor(IN pid_load_local bigint, IN p_iddeudor character varying, IN p_tipopersonadeudor integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_tipos    int[];
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, tipopersonadeudor, iddeudor, tipoingresodeudor, tipomonedaingreso)
    -- Muestrear v_cantidad tipoingresodeudor DISTINTOS. Como dentro de un mismo
    -- iddeudor los tipos serán distintos, la tupla (tipo, moneda) también será única.
    v_tipos := ARRAY(
        SELECT c FROM unnest(ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.ingresodeudores (
                id_load_local, tipopersonadeudor, iddeudor, tipoingresodeudor,
                montoingresodeudor, tipomonedaingreso, fechaverificacioningreso,
                updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_tipopersonadeudor::varchar,
                p_iddeudor,
                v_tipos[j]::varchar,
                round((random() * 10000000 + 100000)::numeric, 2),
                ((ARRAY[1,2])[floor(random() * 2 + 1)])::varchar,
                CASE WHEN random() < 0.7 THEN (CURRENT_DATE - (random() * 365)::int) ELSE NULL END,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_ingresos_deudor] Error fila % de %: % | SQLSTATE=% | deudor=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_iddeudor;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_ingresos_deudor] Error general: % | SQLSTATE=% | deudor=%',
                     SQLERRM, SQLSTATE, p_iddeudor;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_ingresos_deudor(IN pid_load_local bigint, IN p_iddeudor character varying, IN p_tipopersonadeudor integer) OWNER TO postgres;

--
-- TOC entry 508 (class 1255 OID 123210)
-- Name: generar_modificacion(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_modificacion(IN pid_load_local bigint, IN p_idoperacion character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_tipos    int[];
BEGIN
    v_cantidad := floor(random() * 2 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, tipomodificacion)
    -- Muestrear v_cantidad tipos DISTINTOS para evitar duplicados.
    v_tipos := ARRAY(
        SELECT c FROM unnest(ARRAY[
            0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,
            20,21,22,23,24,25,27,28,29
        ]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            INSERT INTO feguslocal.modificacion (
                id_load_local, idoperacioncredito, fechamodificacion,
                tipomodificacion, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                (CURRENT_DATE - (random() * 365)::int),
                v_tipos[j]::varchar,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_modificacion] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_modificacion] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_modificacion(IN pid_load_local bigint, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 529 (class 1255 OID 123213)
-- Name: generar_naturalezagasto(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_naturalezagasto(IN pid_load_local bigint, IN p_idoperacion character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad   int;
    j            int;
    v_porcentaje numeric(5,2);
    v_acumulado  numeric(5,2) := 0;
    v_codigos    int[];
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, tiponaturalezagasto)
    -- Muestrear v_cantidad códigos DISTINTOS del catálogo para evitar duplicados.
    v_codigos := ARRAY(
        SELECT c FROM unnest(ARRAY[
            102,104,106,108,110,112,114,116,118,120,125,126,127,190,202,
            203,204,280,281,282,283,284,285,286,290,302,304,306,308,310,
            312,313,314,316,318,320,322,390
        ]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            IF j = v_cantidad THEN
                v_porcentaje := round((100 - v_acumulado)::numeric, 2);
            ELSE
                v_porcentaje := round((random() * (100 - v_acumulado) / (v_cantidad - j + 1) + 1)::numeric, 2);
                v_acumulado := v_acumulado + v_porcentaje;
            END IF;

            INSERT INTO feguslocal.naturalezagasto (
                id_load_local, idoperacioncredito, tiponaturalezagasto,
                porcentajenaturalezagasto, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                v_codigos[j]::varchar,
                v_porcentaje,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_naturalezagasto] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_naturalezagasto] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_naturalezagasto(IN pid_load_local bigint, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 473 (class 1255 OID 123192)
-- Name: generar_operaciones_deudor(bigint, feguslocal.deudores_type, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_operaciones_deudor(IN pid_load_local bigint, IN p_deudor feguslocal.deudores_type, IN p_cantidad integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    i                       int;
    v_idoperacion           text;
    v_dias_morosidad        int;
    v_indicador_modificada  varchar(1);
    v_indicador_codeudores  varchar(1);
    v_indicador_sindicado   varchar(1);
    v_indicador_climatico   varchar(1);
    v_indicador_especial    varchar(1);
BEGIN
    FOR i IN 1..p_cantidad LOOP
        BEGIN
            v_idoperacion          := feguslocal.generar_id_fegus('OPER','seq_operacion');
            v_dias_morosidad       := floor(random() * 201)::int;
            v_indicador_modificada := CASE WHEN random() < 0.20 THEN 'S' ELSE 'N' END;
            v_indicador_codeudores := CASE WHEN random() < 0.30 THEN 'S' ELSE 'N' END;
            v_indicador_sindicado  := CASE WHEN random() < 0.05 THEN 'S' ELSE 'N' END;
            v_indicador_climatico  := CASE WHEN random() < 0.15 THEN 'S' ELSE 'N' END;
            v_indicador_especial   := CASE WHEN random() < 0.10 THEN 'S' ELSE 'N' END;

            INSERT INTO feguslocal.operacionescredito(
                "id_load_local", "TipoOperacionSFN", "TipoPersonaDeudor", "IdDeudor",
                "IdOperacionCredito", "IdLineaCredito", "IndicadorOperacionModificada",
                "IndicadorPresentaCodeudores", "TipoEnfoque", "TipoSegmento", "CodigoEtapa",
                "CodigoCategoriaRiesgo", "TasaIncumplimiento", "LGDMinimoCombinado",
                "LGDPromedio", "LGDRegulatorio", "TipoOperacion", "TipoCatalogoSUGEF",
                "CodigoPaisDestinoCredito", "CodigoProvinciaDestinoCredito",
                "CodigoCantonDestinoCredito", "CodigoDistritoDestinoCredito",
                "CodigoProvinciaDependenciaCredito", "CodigoCantonDependenciaCredito",
                "TipoCarteraCrediticia", "TipoEstadoOperacionCrediticia",
                "DiasMaximaMorosidad", "MontoFormalizadoOperacionCrediticia",
                "TipoMonedaOperacion", "MontoOperacionAutorizado", "CuentaContablePrincipal",
                "SaldoPrincipalOperacionCrediticia", "CuentaContablePrincipalConDepositoPrevio",
                "SaldoPrincipalConDepositoPrevio", "CuentaContableProductosPorCobrar",
                "SaldoProductosPorCobrar", "CuentaContablePorDesembolsarConCompromiso",
                "SaldoPorDesembolsarConCompromiso", "CuentaContableComisiones",
                "SaldoComisionesOperacionesContingentes",
                "CuentaContableSaldoPendienteUtilizacionSinCompromiso",
                "SaldoPendienteUtilizacionSinCompromiso", "MontoDesembolsado",
                "FechaFormalizacion", "FechaVencimiento", "EAD", "SaldoOperacionSegmentacion",
                "TipoFrecuenciaPagoActualPrincipal", "TipoFrecuenciaPagoActualIntereses",
                "FechaVencimientoPeriodoGraciaPrincipal", "TasaLey7472",
                "TasaInteresNominalVigente", "IndicadorTipoTasa",
                "FactorDeTiempoCalculoIntereses", "IndicadorFormaPagoVigentePrincipal",
                "IndicadorFormaPagoVigenteIntereses", "FechaCorteOperacion",
                "FechaProximoPagoPrincipal", "FechaProximoPagoIntereses",
                "FechaAmortizacionHasta", "FechaInteresHasta", "FechaPagoPactadoPrincipal",
                "FechaPagoPactadoIntereses", "PlazoOperacionDias", "TipoCuotaPrincipal",
                "MontoCuotaPrincipalActual", "MontoCuotaInteresesActual",
                "IndicadorOperacionNueva", "MontoRecuperacionPrincipal",
                "MontoOtrosAumentosDePrincipal", "MontoOtrasDisminucionesDePrincipal",
                "IndicadorBacktoBack", "IndicadorCreditoSindicado",
                "IndicadorOperacionEspecial", "TipoMotivoOperacionEspecial",
                "CodigoClausulaLimiteCredito", "FechaCambioTipoTasa",
                "TipoFrecuenciaAjusteTasaInteresVariable",
                "TipoParametroReferenciaTasaInteresVariable",
                "PorcentajeComponenteVariableTasaInteresVariable",
                "PorcentajeComponenteFijoTasaInteresVariable",
                "LimiteInferiorTasaInteresVariable", "LimiteSuperiorTasaInteresVariable",
                "MontoEstimacionEspecifica", "MontoEstimacionAvales",
                "TipoProgramaAutorizadoSBD", "IndicadorCreditoGrupalSolidarioSBD",
                "TipoSectorPrioritarioDeudorSBD", "IdFondeadorSBD",
                "TipoPersonaIdFondeadorSBD", "IndicadorOperacionCedidaEnGarantia",
                "PorcentajePonderadorSPD", "PorcentajePonderadorSPC",
                "PorcentajeIndicadorLTV", "IndicadorCambioClimatico",
                "TipoClasificacionRiesgoClimatico", "TipoMetodologiaClimatica",
                "TipoPotencialidadImpactoClimatico", "updated_at_utc"
            )
            VALUES (
                pid_load_local,
                (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],          -- TipoOperacionSFN
                p_deudor.TipoPersonaDeudor,
                p_deudor.IdDeudor,
                v_idoperacion,                                          -- IdOperacionCredito
                NULL,                                                   -- IdLineaCredito
                v_indicador_modificada,                                 -- IndicadorOperacionModificada
                v_indicador_codeudores,                                 -- IndicadorPresentaCodeudores
                (ARRAY[0,1,2])[floor(random() * 3 + 1)],                -- TipoEnfoque
                (ARRAY[0,1,2,3,4,5,6,7])[floor(random() * 8 + 1)],      -- TipoSegmento
                NULL,                                                   -- CodigoEtapa (confirmado: NULL)
                NULL,                                                   -- CodigoCategoriaRiesgo (confirmado: NULL)
                round((random() * 99.99)::numeric, 2),                  -- TasaIncumplimiento
                round((random() * 100)::numeric, 2),                    -- LGDMinimoCombinado
                round((random() * 100)::numeric, 2),                    -- LGDPromedio
                round((random() * 100)::numeric, 2),                    -- LGDRegulatorio
                (ARRAY[1,2,3,4,5,6,7,8,9])[floor(random() * 9 + 1)],    -- TipoOperacion
                (ARRAY[1,2,3,4,5,6,7,8,14,33,34,35,36])[floor(random() * 13 + 1)], -- TipoCatalogoSUGEF
                'CR',                                                   -- CodigoPaisDestinoCredito (confirmado: 'CR')
                NULL,                                                   -- CodigoProvinciaDestinoCredito (confirmado: NULL)
                NULL,                                                   -- CodigoCantonDestinoCredito (confirmado: NULL)
                NULL,                                                   -- CodigoDistritoDestinoCredito (confirmado: NULL)
                NULL,                                                   -- CodigoProvinciaDependenciaCredito (confirmado: NULL)
                NULL,                                                   -- CodigoCantonDependenciaCredito (confirmado: NULL)
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11])[floor(random() * 12 + 1)], -- TipoCarteraCrediticia
                (ARRAY[1,2,3,4,5,6])[floor(random() * 6 + 1)],          -- TipoEstadoOperacionCrediticia
                v_dias_morosidad,                                       -- DiasMaximaMorosidad
                round((random() * 50000000)::numeric, 2),               -- MontoFormalizadoOperacionCrediticia
                (ARRAY[1,2])[floor(random() * 2 + 1)],                  -- TipoMonedaOperacion (confirmado: 1 ó 2)
                round((random() * 50000000)::numeric, 2),               -- MontoOperacionAutorizado
                (ARRAY[13131101,13401200,13132125,13233201,13231203,13332125,13131104,
                       13331102,13131203,13331203,13231104,13231204,13131201,13131102,
                       13231101,13131103,13133101,13232125,13233101,13131110,13131210,
                       13231202,13136101,13333201,13331202,13331103,13401100,13133201,
                       13231102,13231201,13333101,13231103,13402100,13402200,13132134,
                       13131204,13131202])[floor(random() * 37 + 1)],   -- CuentaContablePrincipal
                round((random() * 50000000)::numeric, 2),               -- SaldoPrincipalOperacionCrediticia
                NULL,                                                   -- CuentaContablePrincipalConDepositoPrevio
                0,                                                      -- SaldoPrincipalConDepositoPrevio
                (ARRAY[13831101,13832134,13831110,13831102,13831210,13831103,13831202,
                       13836101,13833101,13831204,13833201,13831203,13831104,13831201,
                       13832125])[floor(random() * 15 + 1)],            -- CuentaContableProductosPorCobrar
                round((random() * 1000000)::numeric, 2),                -- SaldoProductosPorCobrar
                (ARRAY[61502200,61901200,61901100])[floor(random() * 3 + 1)], -- CuentaContablePorDesembolsarConCompromiso
                round((random() * 500000)::numeric, 2),                 -- SaldoPorDesembolsarConCompromiso
                NULL,                                                   -- CuentaContableComisiones
                0,                                                      -- SaldoComisionesOperacionesContingentes
                NULL,                                                   -- CuentaContableSaldoPendienteUtilizacionSinCompromiso
                0,                                                      -- SaldoPendienteUtilizacionSinCompromiso
                round((random() * 50000000)::numeric, 2),               -- MontoDesembolsado
                (CURRENT_DATE - (random() * 1825)::int),                -- FechaFormalizacion
                (CURRENT_DATE + (random() * 3650)::int),                -- FechaVencimiento (futura)
                round((random() * 50000000)::numeric, 2),               -- EAD
                round((random() * 50000000)::numeric, 2),               -- SaldoOperacionSegmentacion
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 13 + 1)], -- TipoFrecuenciaPagoActualPrincipal
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 13 + 1)], -- TipoFrecuenciaPagoActualIntereses
                NULL,                                                   -- FechaVencimientoPeriodoGraciaPrincipal
                round((random() * 99.99)::numeric, 2),                  -- TasaLey7472
                round((random() * 99.99)::numeric, 2),                  -- TasaInteresNominalVigente
                (ARRAY['V','F'])[floor(random() * 2 + 1)],              -- IndicadorTipoTasa
                '4',                                                    -- FactorDeTiempoCalculoIntereses
                'V',                                                    -- IndicadorFormaPagoVigentePrincipal
                'V',                                                    -- IndicadorFormaPagoVigenteIntereses
                (CURRENT_DATE - (random() * 365)::int),                 -- FechaCorteOperacion
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaProximoPagoPrincipal
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaProximoPagoIntereses
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaAmortizacionHasta
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaInteresHasta
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaPagoPactadoPrincipal
                (CURRENT_DATE + (random() * 365)::int),                 -- FechaPagoPactadoIntereses
                (ARRAY[180,360,540,720,1080,1800])[floor(random() * 6 + 1)], -- PlazoOperacionDias
                (ARRAY[1,2,3,4,5])[floor(random() * 5 + 1)],            -- TipoCuotaPrincipal
                round((random() * 1000000)::numeric, 2),                -- MontoCuotaPrincipalActual
                round((random() * 1000000)::numeric, 2),                -- MontoCuotaInteresesActual
                CASE WHEN random() < 0.30 THEN 'S' ELSE 'N' END,        -- IndicadorOperacionNueva
                round((random() * 5000000)::numeric, 2),                -- MontoRecuperacionPrincipal
                round((random() * 5000000)::numeric, 2),                -- MontoOtrosAumentosDePrincipal
                round((random() * 5000000)::numeric, 2),                -- MontoOtrasDisminucionesDePrincipal
                CASE WHEN random() < 0.05 THEN 'S' ELSE 'N' END,        -- IndicadorBacktoBack
                v_indicador_sindicado,                                  -- IndicadorCreditoSindicado
                v_indicador_especial,                                   -- IndicadorOperacionEspecial
                CASE WHEN v_indicador_especial = 'S'
                     THEN (ARRAY[0,1,2,3])[floor(random() * 4 + 1)]
                     ELSE NULL END,                                     -- TipoMotivoOperacionEspecial
                0,                                                      -- CodigoClausulaLimiteCredito
                NULL,                                                   -- FechaCambioTipoTasa
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12])[floor(random() * 13 + 1)], -- TipoFrecuenciaAjusteTasaInteresVariable
                (ARRAY[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18])[floor(random() * 18 + 1)], -- TipoParametroReferenciaTasaInteresVariable
                round((random() * 50)::numeric, 2),                     -- PorcentajeComponenteVariableTasaInteresVariable
                round((random() * 50)::numeric, 2),                     -- PorcentajeComponenteFijoTasaInteresVariable
                round((random() * 5)::numeric, 2),                      -- LimiteInferiorTasaInteresVariable
                round((random() * 30)::numeric, 2),                     -- LimiteSuperiorTasaInteresVariable
                round((random() * 5000000)::numeric, 2),                -- MontoEstimacionEspecifica
                round((random() * 1000000)::numeric, 2),                -- MontoEstimacionAvales
                (ARRAY[0,30001,30002,30003,30004,30005,30019,40001,40002,40003,40010])[floor(random() * 11 + 1)], -- TipoProgramaAutorizadoSBD
                CASE WHEN random() < 0.10 THEN 1 ELSE 0 END,            -- IndicadorCreditoGrupalSolidarioSBD
                (ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12,13])[floor(random() * 14 + 1)], -- TipoSectorPrioritarioDeudorSBD
                NULL,                                                   -- IdFondeadorSBD
                NULL,                                                   -- TipoPersonaIdFondeadorSBD
                CASE WHEN random() < 0.05 THEN 'S' ELSE 'N' END,        -- IndicadorOperacionCedidaEnGarantia
                round((random() * 100)::numeric, 2),                    -- PorcentajePonderadorSPD
                round((random() * 100)::numeric, 2),                    -- PorcentajePonderadorSPC
                round((random() * 100)::numeric, 2),                    -- PorcentajeIndicadorLTV
                v_indicador_climatico,                                  -- IndicadorCambioClimatico
                CASE WHEN v_indicador_climatico = 'S'
                     THEN (ARRAY[0,1,2,3])[floor(random() * 4 + 1)]
                     ELSE NULL END,                                     -- TipoClasificacionRiesgoClimatico
                CASE WHEN v_indicador_climatico = 'S'
                     THEN (ARRAY[0,1,2])[floor(random() * 3 + 1)]
                     ELSE NULL END,                                     -- TipoMetodologíaClimático
                CASE WHEN v_indicador_climatico = 'S'
                     THEN (ARRAY[0,1,2,3,4,5,6,7,8,9])[floor(random() * 10 + 1)]
                     ELSE NULL END,                                     -- TipoPotencialidadImpactoClimatico
                CURRENT_DATE
            );

            ----------------------------------------------------------------
            -- Hijos por operación
            ----------------------------------------------------------------
            CALL feguslocal.generar_actividadeconomica(pid_load_local, v_idoperacion);
            CALL feguslocal.generar_naturalezagasto(pid_load_local, v_idoperacion);
            CALL feguslocal.generar_origenrecursos(pid_load_local, v_idoperacion);
            CALL feguslocal.generar_cuentasxcobrar(pid_load_local, v_idoperacion);
            CALL feguslocal.generar_cuentasporcobrarnosasociadas(
                pid_load_local, v_idoperacion, p_deudor.TipoPersonaDeudor::int);
            CALL feguslocal.generar_operacionescompradas(
                pid_load_local, v_idoperacion, p_deudor.IdDeudor, p_deudor.TipoPersonaDeudor::int);

            IF v_indicador_codeudores = 'S' THEN
                CALL feguslocal.generar_codeudores(pid_load_local, v_idoperacion);
            END IF;

            IF v_indicador_sindicado = 'S' THEN
                CALL feguslocal.generar_creditossindicados(pid_load_local, v_idoperacion);
            END IF;

            IF v_indicador_modificada = 'S' THEN
                CALL feguslocal.generar_modificacion(pid_load_local, v_idoperacion);
            END IF;

            IF v_indicador_climatico = 'S' THEN
                CALL feguslocal.generar_cambioclimatico(pid_load_local, v_idoperacion);
            END IF;

            IF v_dias_morosidad > 30 THEN
                CALL feguslocal.generar_cuotasatrasadas(
                    pid_load_local, v_idoperacion, p_deudor.IdDeudor,
                    p_deudor.TipoPersonaDeudor::int, v_dias_morosidad);
            END IF;

            -- Garantías (1-3 por operación, cada una se enruta por tipogarantia)
            CALL feguslocal.generar_garantia_operacion(
                pid_load_local, p_deudor.IdDeudor, p_deudor.TipoPersonaDeudor::int, v_idoperacion);

        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_operaciones_deudor] Error en operación %: % | SQLSTATE=% | deudor=%',
                             COALESCE(v_idoperacion, '<n/a>'), SQLERRM, SQLSTATE, p_deudor.IdDeudor;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_operaciones_deudor] Error general: % | SQLSTATE=% | deudor=%',
                     SQLERRM, SQLSTATE, p_deudor.IdDeudor;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_operaciones_deudor(IN pid_load_local bigint, IN p_deudor feguslocal.deudores_type, IN p_cantidad integer) OWNER TO postgres;

--
-- TOC entry 494 (class 1255 OID 123189)
-- Name: generar_operacionesbienesrealizables(bigint); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_operacionesbienesrealizables(IN pid_load_local bigint)
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


ALTER PROCEDURE feguslocal.generar_operacionesbienesrealizables(IN pid_load_local bigint) OWNER TO postgres;

--
-- TOC entry 500 (class 1255 OID 123178)
-- Name: generar_operacionescompradas(bigint, character varying, character varying, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_operacionescompradas(IN pid_load_local bigint, IN p_idoperacion character varying, IN p_iddeudor character varying, IN p_tipopersonadeudor integer)
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


ALTER PROCEDURE feguslocal.generar_operacionescompradas(IN pid_load_local bigint, IN p_idoperacion character varying, IN p_iddeudor character varying, IN p_tipopersonadeudor integer) OWNER TO postgres;

--
-- TOC entry 487 (class 1255 OID 123167)
-- Name: generar_operacionesnoreportadas(bigint, character varying, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_operacionesnoreportadas(IN pid_load_local bigint, IN p_iddeudor character varying, IN p_tipopersonadeudor integer)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad int;
    j int;
    v_idoperacion text;
BEGIN
    v_cantidad := floor(random() * 2 + 1)::int;

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            v_idoperacion := feguslocal.generar_id_fegus('OPNR','seq_operacion');

            INSERT INTO feguslocal.operacionesnoreportadas (
                id_load_local, tipopersona, iddeudor, idoperacion,
                motivoliquidacion, fechaliquidacion,
                saldoprincipalliquidado, saldoproductosliquidado,
                idoperacionnueva, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_tipopersonadeudor::varchar,
                p_iddeudor,
                v_idoperacion,
                ((ARRAY[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,
                       21,22,23,24,25,26,27,28,29,30,31,32,33,34,98])[floor(random() * 36 + 1)])::varchar,
                (CURRENT_DATE - (random() * 730)::int),
                round((random() * 5000000)::numeric, 2),
                round((random() * 500000)::numeric, 2),
                CASE WHEN random() < 0.3 THEN feguslocal.generar_id_fegus('OPER','seq_operacion') ELSE NULL END,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_operacionesnoreportadas] Error fila % de %: % | SQLSTATE=% | deudor=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_iddeudor;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_operacionesnoreportadas] Error general: % | SQLSTATE=% | deudor=%',
                     SQLERRM, SQLSTATE, p_iddeudor;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_operacionesnoreportadas(IN pid_load_local bigint, IN p_iddeudor character varying, IN p_tipopersonadeudor integer) OWNER TO postgres;

--
-- TOC entry 468 (class 1255 OID 123212)
-- Name: generar_origenrecursos(bigint, character varying); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.generar_origenrecursos(IN pid_load_local bigint, IN p_idoperacion character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_cantidad   int;
    j            int;
    v_porcentaje numeric(5,2);
    v_acumulado  numeric(5,2) := 0;
    v_codigos    int[];
BEGIN
    v_cantidad := floor(random() * 3 + 1)::int;

    -- PK: (id_load_local, idoperacioncredito, tipoorigenrecursos)
    -- Muestrear v_cantidad códigos DISTINTOS del catálogo para evitar duplicados.
    v_codigos := ARRAY(
        SELECT c FROM unnest(ARRAY[
            102,104,106,108,110,112,114,116,118,119,120,121,122,123,190,
            201,211,212,213,214,215,216,221,222,223,225,226,301,302,303,
            305,306,401,402,403,405,406,432,433,434,435,501
        ]) c
        ORDER BY random()
        LIMIT v_cantidad
    );

    FOR j IN 1..v_cantidad LOOP
        BEGIN
            IF j = v_cantidad THEN
                v_porcentaje := round((100 - v_acumulado)::numeric, 2);
            ELSE
                v_porcentaje := round((random() * (100 - v_acumulado) / (v_cantidad - j + 1) + 1)::numeric, 2);
                v_acumulado := v_acumulado + v_porcentaje;
            END IF;

            INSERT INTO feguslocal.origenrecursos (
                id_load_local, idoperacioncredito, tipoorigenrecursos,
                porcentajeorigenrecursos, updated_at_utc
            )
            VALUES (
                pid_load_local,
                p_idoperacion,
                v_codigos[j]::varchar,
                v_porcentaje,
                CURRENT_DATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                RAISE NOTICE '[generar_origenrecursos] Error fila % de %: % | SQLSTATE=% | operacion=%',
                             j, v_cantidad, SQLERRM, SQLSTATE, p_idoperacion;
                RAISE;
        END;
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE '[generar_origenrecursos] Error general: % | SQLSTATE=% | operacion=%',
                     SQLERRM, SQLSTATE, p_idoperacion;
        RAISE;
END;
$$;


ALTER PROCEDURE feguslocal.generar_origenrecursos(IN pid_load_local bigint, IN p_idoperacion character varying) OWNER TO postgres;

--
-- TOC entry 471 (class 1255 OID 123196)
-- Name: gerancion_datos_dummy(integer, integer); Type: PROCEDURE; Schema: feguslocal; Owner: postgres
--

CREATE PROCEDURE feguslocal.gerancion_datos_dummy(IN p_id_cliente integer, IN p_num_registros integer)
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER PROCEDURE feguslocal.gerancion_datos_dummy(IN p_id_cliente integer, IN p_num_registros integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 309 (class 1259 OID 74047)
-- Name: actividadeconomica; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.actividadeconomica (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipoactividadeconomica character varying(10) NOT NULL,
    porcentajeactividadeconomica numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.actividadeconomica OWNER TO postgres;

--
-- TOC entry 501 (class 1255 OID 131928)
-- Name: obtener_actividadeconomica_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_actividadeconomica_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.actividadeconomica
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.actividadeconomica
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.actividadeconomica t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_actividadeconomica_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 320 (class 1259 OID 74169)
-- Name: bienesrealizables; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.bienesrealizables (
    id_load_local bigint NOT NULL,
    tipoadquisicionbien character varying(10) NOT NULL,
    idbienrealizable character varying(50) NOT NULL,
    indicadorgarantia character varying(1) NOT NULL,
    idgarantia character varying(50) NOT NULL,
    idbien character varying(50) NOT NULL,
    tipobien character varying(10) NOT NULL,
    fechaadjudicaciondacionbien date NOT NULL,
    saldoregistrocontable numeric(18,2) NOT NULL,
    tipomonedasaldoregistrocontable character varying(5) NOT NULL,
    cuentacatalogosugef character varying(50) NOT NULL,
    tipocatalogosugef character varying(10) NOT NULL,
    fechaultimatasacionbien date NOT NULL,
    montoultimatasacion numeric(18,2) NOT NULL,
    tipomonedamontoavaluo character varying(5) NOT NULL,
    tipopersonatasador character varying(2) NOT NULL,
    idtasador character varying(50) NOT NULL,
    tipopersonaempresatasadora character varying(2) NOT NULL,
    idempresatasadora character varying(50) NOT NULL,
    saldocontablecreditocancelado numeric(18,2) NOT NULL,
    tipomonedasaldocontablecreditocancelado character varying(5) NOT NULL,
    montoestimacion numeric(18,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.bienesrealizables OWNER TO postgres;

--
-- TOC entry 483 (class 1255 OID 131930)
-- Name: obtener_bienesrealizables_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_bienesrealizables_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.bienesrealizables
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.bienesrealizables
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.bienesrealizables t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_bienesrealizables_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 319 (class 1259 OID 74158)
-- Name: bienesrealizablesnoreportados; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.bienesrealizablesnoreportados (
    id_load_local bigint NOT NULL,
    idbienrealizable character varying(50) NOT NULL,
    indicadorgarantia character varying(1) NOT NULL,
    idgarantia character varying(50) NOT NULL,
    idbien character varying(50) NOT NULL,
    tipobien character varying(10) NOT NULL,
    tipomotivobienrealizablenoreportado character varying(10) NOT NULL,
    ultimovalorcontable numeric(18,2) NOT NULL,
    valorrecuperadoneto numeric(18,2) NOT NULL,
    idoperacioncreditofinanciamiento character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.bienesrealizablesnoreportados OWNER TO postgres;

--
-- TOC entry 486 (class 1255 OID 131929)
-- Name: obtener_bienesrealizablesnoreportados_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_bienesrealizablesnoreportados_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.bienesrealizablesnoreportados
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.bienesrealizablesnoreportados
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.bienesrealizablesnoreportados t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_bienesrealizablesnoreportados_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 316 (class 1259 OID 74125)
-- Name: cambioclimatico; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.cambioclimatico (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipotema character varying(10) NOT NULL,
    tiposubtema character varying(10) NOT NULL,
    tipoactividad character varying(10) NOT NULL,
    tipoambito character varying(10) NOT NULL,
    tipofuentefinanciamiento character varying(10) NOT NULL,
    tipofondofinanciamiento character varying(10) NOT NULL,
    saldomontoclimatico numeric(18,2) NOT NULL,
    codigomodalidad character varying(10) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.cambioclimatico OWNER TO postgres;

--
-- TOC entry 519 (class 1255 OID 131931)
-- Name: obtener_cambioclimatico_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_cambioclimatico_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.cambioclimatico
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.cambioclimatico
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.cambioclimatico t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_cambioclimatico_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 313 (class 1259 OID 74092)
-- Name: codeudores; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.codeudores (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersonacodeudor character varying(2) NOT NULL,
    idcodeudor character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.codeudores OWNER TO postgres;

--
-- TOC entry 489 (class 1255 OID 131932)
-- Name: obtener_codeudores_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_codeudores_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.codeudores
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.codeudores
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.codeudores t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_codeudores_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 312 (class 1259 OID 74081)
-- Name: creditossindicados; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.creditossindicados (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersona character varying(2) NOT NULL,
    identidadcreditosindicado character varying(50) NOT NULL,
    idoperacioncreditoentidadcreditosindicado character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.creditossindicados OWNER TO postgres;

--
-- TOC entry 467 (class 1255 OID 131933)
-- Name: obtener_creditossindicados_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_creditossindicados_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.creditossindicados
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.creditossindicados
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.creditossindicados t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_creditossindicados_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 322 (class 1259 OID 74191)
-- Name: cuentasporcobrarnosasociadas; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.cuentasporcobrarnosasociadas (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    idpersona character varying(50) NOT NULL,
    tipomonedamonto character varying(5) NOT NULL,
    montooriginal numeric(18,2) NOT NULL,
    tipocatalogosugef character varying(10) NOT NULL,
    cuentacontablesaldoprincipal character varying(50) NOT NULL,
    saldoprincipal numeric(18,2) NOT NULL,
    cuentacontablesaldoproductosporcobrar character varying(50) NOT NULL,
    saldoproductosporcobrar numeric(18,2) NOT NULL,
    fecharegistrocontable date NOT NULL,
    fechaexigibilidad date NOT NULL,
    fechavencimiento date NOT NULL,
    montoestimacionregistrada numeric(18,2) NOT NULL,
    tipodependencia character varying(10) NOT NULL,
    diasmora integer NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.cuentasporcobrarnosasociadas OWNER TO postgres;

--
-- TOC entry 532 (class 1255 OID 131934)
-- Name: obtener_cuentasporcobrarnosasociadas_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_cuentasporcobrarnosasociadas_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.cuentasporcobrarnosasociadas
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.cuentasporcobrarnosasociadas
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.cuentasporcobrarnosasociadas t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_cuentasporcobrarnosasociadas_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 311 (class 1259 OID 74069)
-- Name: cuentasxcobrar; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.cuentasxcobrar (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    idcuentacobrarasociada character varying(50) NOT NULL,
    cuentacontablecuentacobrarasociada character varying(50) NOT NULL,
    tipocatalogosugef character varying(10) NOT NULL,
    saldocuentacobrarasociada numeric(18,2) NOT NULL,
    tipomonedacuentacobrarasociada character varying(5) NOT NULL,
    diasatrasocuentacobrarasociada integer NOT NULL,
    fecharegistrocuentacobrarasociada date NOT NULL,
    fechavencimientocuentacobrarasociada date NOT NULL,
    concepto character varying(255),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.cuentasxcobrar OWNER TO postgres;

--
-- TOC entry 495 (class 1255 OID 131935)
-- Name: obtener_cuentasxcobrar_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_cuentasxcobrar_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.cuentasxcobrar
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.cuentasxcobrar
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.cuentasxcobrar t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_cuentasxcobrar_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 323 (class 1259 OID 74202)
-- Name: cuotasatrasadas; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.cuotasatrasadas (
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipocuota character varying(10) NOT NULL,
    numerocuotaatrasada integer NOT NULL,
    diasatraso integer NOT NULL,
    montocuotaatrasada numeric(18,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.cuotasatrasadas OWNER TO postgres;

--
-- TOC entry 475 (class 1255 OID 131936)
-- Name: obtener_cuotasatrasadas_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_cuotasatrasadas_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.cuotasatrasadas
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.cuotasatrasadas
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.cuotasatrasadas t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_cuotasatrasadas_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 326 (class 1259 OID 74235)
-- Name: deudores; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.deudores (
    id_load_local bigint NOT NULL,
    tipodeudorsfn integer,
    tipopersonadeudor numeric NOT NULL,
    iddeudor character varying(30) NOT NULL,
    codigosectoreconomico numeric,
    tipocapacidadpago integer,
    saldototalsegmentacion numeric,
    tipocondicionespecialdeudor integer,
    fechacalificacionriesgo text,
    tipoindicadorgeneradordivisas integer,
    tipoasignacioncalificacion integer,
    categoriacalificacion numeric,
    calificacionriesgo text,
    codigoempresacalificadora numeric,
    indicadorvinculadoentidad character varying,
    indicadorvinculadogrupofinanciero character varying,
    idgrupointereseconomico numeric,
    tipocomportamientopago integer,
    tipoactividadeconomicadeudor character varying(14),
    tipocomportamientopagosbd integer,
    tipobeneficiariosbd integer,
    totaloperacionesreestructuradassbd integer,
    tipoindicadorgeneradordivisassbd integer,
    riesgocambiariodeudor integer,
    montoingresototaldeudor numeric,
    totalcargamensualcsd numeric,
    indicadorcsd numeric,
    indicadorcic character varying(1),
    saldomoramayorultmeses1421 numeric,
    nummesesmoramayor1421 integer,
    saldomoramayorultmeses1516 numeric,
    nummesesmoramayor1516 integer,
    numdiasatraso1421 integer,
    numdiasatraso1516 integer,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.deudores OWNER TO postgres;

--
-- TOC entry 470 (class 1255 OID 131937)
-- Name: obtener_deudores_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_deudores_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.deudores
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.deudores
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY
    SELECT *
    FROM feguslocal.deudores d
    WHERE d.id_load_local = p_id_load_local
    AND d.seq > p_last_seq
    ORDER BY d.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_deudores_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 318 (class 1259 OID 74147)
-- Name: fideicomiso; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.fideicomiso (
    id_load_local bigint NOT NULL,
    idfideicomisogarantia character varying(50) NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date NOT NULL,
    valornominalfideicomiso numeric(18,2) NOT NULL,
    tipomonedavalornominalfideicomiso character varying(5) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.fideicomiso OWNER TO postgres;

--
-- TOC entry 505 (class 1255 OID 131938)
-- Name: obtener_fideicomiso_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_fideicomiso_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.fideicomiso
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.fideicomiso
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.fideicomiso t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_fideicomiso_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 358 (class 1259 OID 123148)
-- Name: garantiascartascredito; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.garantiascartascredito (
    id_load_local bigint NOT NULL,
    idgarantiacartacredito character varying(25) NOT NULL,
    tipomitigadorcartacredito numeric(2,0) NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date,
    tipopersona numeric(2,0) NOT NULL,
    identidadcartacredito character varying(30) NOT NULL,
    valornominalgarantia numeric(20,2) NOT NULL,
    tipomonedavalornominal numeric(6,0) NOT NULL,
    tipoasignacioncalificacion numeric(1,0) NOT NULL,
    codigocalificacioncategoria numeric(2,0) NOT NULL,
    factor_y numeric(3,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.garantiascartascredito OWNER TO postgres;

--
-- TOC entry 504 (class 1255 OID 131939)
-- Name: obtener_garantiascartascredito_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_garantiascartascredito_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.garantiascartascredito
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiascartascredito
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiascartascredito t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_garantiascartascredito_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 354 (class 1259 OID 123120)
-- Name: garantiasfacturascedidas; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.garantiasfacturascedidas (
    id_load_local bigint NOT NULL,
    idgarantiafacturacedida character varying(25) NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date,
    tipopersona numeric(2,0) NOT NULL,
    idobligado character varying(30) NOT NULL,
    valornominalgarantia numeric(20,2) NOT NULL,
    tipomonedavalornominal numeric(6,0) NOT NULL,
    porcentajeajusterc numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.garantiasfacturascedidas OWNER TO postgres;

--
-- TOC entry 499 (class 1255 OID 131940)
-- Name: obtener_garantiasfacturascedidas_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_garantiasfacturascedidas_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.garantiasfacturascedidas
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiasfacturascedidas
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiasfacturascedidas t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_garantiasfacturascedidas_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 355 (class 1259 OID 123127)
-- Name: garantiasfiduciarias; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.garantiasfiduciarias (
    id_load_local bigint NOT NULL,
    idgarantiafiduciaria character varying(25) NOT NULL,
    tipopersona numeric(2,0) NOT NULL,
    idfiador character varying(30) NOT NULL,
    salarionetofiador numeric(20,2),
    fechaverificacionasalariado date,
    montoavalado numeric(20,2),
    porcentajemitigacionfondo numeric(5,2),
    porcentajeestimacionminimofondo numeric(5,2),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.garantiasfiduciarias OWNER TO postgres;

--
-- TOC entry 493 (class 1255 OID 131941)
-- Name: obtener_garantiasfiduciarias_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_garantiasfiduciarias_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.garantiasfiduciarias
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiasfiduciarias
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiasfiduciarias t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_garantiasfiduciarias_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 325 (class 1259 OID 74224)
-- Name: garantiasmobiliarias; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.garantiasmobiliarias (
    id_load_local bigint NOT NULL,
    idgarantiamobiliaria character varying(50) NOT NULL,
    fechapublicidadgm date NOT NULL,
    montogarantiamobiliaria numeric(18,2) NOT NULL,
    fechavencimientogm date NOT NULL,
    fechamontoreferencia date NOT NULL,
    montoreferencia numeric(18,2) NOT NULL,
    tipomonedamontoreferencia character varying(5) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.garantiasmobiliarias OWNER TO postgres;

--
-- TOC entry 520 (class 1255 OID 131942)
-- Name: obtener_garantiasmobiliarias_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_garantiasmobiliarias_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.garantiasmobiliarias
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiasmobiliarias
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiasmobiliarias t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_garantiasmobiliarias_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 306 (class 1259 OID 74014)
-- Name: garantiasoperacion; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.garantiasoperacion (
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipogarantia character varying(10) NOT NULL,
    idgarantia character varying(50) NOT NULL,
    indicadorformatraspasobien character varying(1) NOT NULL,
    idgarantiatraspaso character varying(50) NOT NULL,
    tipomitigador character varying(10) NOT NULL,
    tipodocumentolegal character varying(10) NOT NULL,
    valorajustadogarantia numeric(18,2) NOT NULL,
    tipoinscripciongarantia character varying(10) NOT NULL,
    porcentajeresponsabilidadgarantia numeric(5,2) NOT NULL,
    valornominalgarantia numeric(18,2) NOT NULL,
    fechapresentacionregistrogarantia date,
    tipomonedavalornominalgarantia character varying(5),
    fechaconstituciongarantia date,
    fechavencimientogarantia date,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.garantiasoperacion OWNER TO postgres;

--
-- TOC entry 457 (class 1255 OID 131943)
-- Name: obtener_garantiasoperacion_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_garantiasoperacion_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.garantiasoperacion
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiasoperacion
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiasoperacion t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_garantiasoperacion_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 353 (class 1259 OID 123106)
-- Name: garantiaspolizas; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.garantiaspolizas (
    id_load_local bigint NOT NULL,
    idgarantia character varying(25) NOT NULL,
    tipogarantia numeric(5,0) NOT NULL,
    tipobiengarantia numeric(5,0) NOT NULL,
    tipopoliza numeric(2,0) NOT NULL,
    montopoliza numeric(20,2) NOT NULL,
    fechavencimientopoliza date NOT NULL,
    indicadorcoberturaspoliza character varying(1) NOT NULL,
    tipopersonabeneficiario numeric(2,0) NOT NULL,
    idbeneficiario character varying(30) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.garantiaspolizas OWNER TO postgres;

--
-- TOC entry 516 (class 1255 OID 131944)
-- Name: obtener_garantiaspolizas_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_garantiaspolizas_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.garantiaspolizas
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiaspolizas
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiaspolizas t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_garantiaspolizas_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 356 (class 1259 OID 123134)
-- Name: garantiasreales; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.garantiasreales (
    id_load_local bigint NOT NULL,
    idgarantiareal character varying(25) NOT NULL,
    tipobiengarantiareal numeric(5,0) NOT NULL,
    montoultimatasacionterreno numeric(20,2) NOT NULL,
    montoultimatasacionnoterreno numeric(20,2) NOT NULL,
    fechaultimatasaciongarantia date NOT NULL,
    fechaultimoseguimientogarantia date NOT NULL,
    tipomonedatasacion numeric(6,0) NOT NULL,
    fechaconstruccion date,
    tipopersonatasador numeric(2,0) NOT NULL,
    idtasador character varying(30) NOT NULL,
    tipopersonaempresatasadora numeric(2,0),
    idempresatasadora character varying(30),
    indicadorpolizagarantiareal character varying(1) NOT NULL,
    tipocolateralreal numeric(2,0) NOT NULL,
    porcentajerecuperacioncolateralreal numeric(5,2) NOT NULL,
    tiempo numeric(2,0) NOT NULL,
    porcentajefactordescuentotiempo numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.garantiasreales OWNER TO postgres;

--
-- TOC entry 526 (class 1255 OID 131945)
-- Name: obtener_garantiasreales_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_garantiasreales_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.garantiasreales
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiasreales
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiasreales t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_garantiasreales_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 357 (class 1259 OID 123141)
-- Name: garantiasvalores; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.garantiasvalores (
    id_load_local bigint NOT NULL,
    idgarantiavalor character varying(25) NOT NULL,
    tipoclasificacioninstrumento numeric(1,0) NOT NULL,
    tipopersona numeric(2,0),
    idemisor character varying(30),
    idinstrumento character varying(25) NOT NULL,
    serieinstrumento character varying(20),
    premio numeric(9,6),
    codigoisin character varying(25) NOT NULL,
    tipoasignacioncalificacion numeric(1,0) NOT NULL,
    categoriacalificacion numeric(1,0),
    codigocalificacionriesgo character varying(30),
    codigoempresacalificadora numeric(2,0),
    valorfacial numeric(20,2),
    tipomonedavalorfacial numeric(6,0),
    valormercado numeric(20,2) NOT NULL,
    tipomonedavalormercado numeric(6,0),
    fechaconstitucion date NOT NULL,
    fechavencimiento date,
    tipocolateralfinanciero numeric(2,0) NOT NULL,
    codigocalificacioninstrumento numeric(2,0) NOT NULL,
    porcentajeajusterc numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.garantiasvalores OWNER TO postgres;

--
-- TOC entry 523 (class 1255 OID 131946)
-- Name: obtener_garantiasvalores_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_garantiasvalores_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.garantiasvalores
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.garantiasvalores
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.garantiasvalores t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_garantiasvalores_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 321 (class 1259 OID 74180)
-- Name: gravamenes; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.gravamenes (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    idgarantia character varying(50) NOT NULL,
    tipomitigador character varying(10) NOT NULL,
    tipodocumentolegal character varying(10) NOT NULL,
    tipogradogravamenes character varying(10) NOT NULL,
    tipopersonaacreedor character varying(2) NOT NULL,
    idacreedor character varying(50) NOT NULL,
    montogradogravamen numeric(18,2) NOT NULL,
    tipomonedamonto character varying(5) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.gravamenes OWNER TO postgres;

--
-- TOC entry 463 (class 1255 OID 131947)
-- Name: obtener_gravamenes_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_gravamenes_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.gravamenes
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.gravamenes
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.gravamenes t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_gravamenes_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 307 (class 1259 OID 74025)
-- Name: ingresodeudores; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.ingresodeudores (
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    tipoingresodeudor character varying(10) NOT NULL,
    montoingresodeudor numeric(18,2) NOT NULL,
    tipomonedaingreso character varying(5) NOT NULL,
    fechaverificacioningreso date,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.ingresodeudores OWNER TO postgres;

--
-- TOC entry 465 (class 1255 OID 131948)
-- Name: obtener_ingresodeudores_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_ingresodeudores_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.ingresodeudores
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.ingresodeudores
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.ingresodeudores t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_ingresodeudores_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 314 (class 1259 OID 74103)
-- Name: modificacion; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.modificacion (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    fechamodificacion date NOT NULL,
    tipomodificacion character varying(10) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.modificacion OWNER TO postgres;

--
-- TOC entry 480 (class 1255 OID 131949)
-- Name: obtener_modificacion_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_modificacion_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.modificacion
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.modificacion
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.modificacion t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_modificacion_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 310 (class 1259 OID 74058)
-- Name: naturalezagasto; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.naturalezagasto (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tiponaturalezagasto character varying(10) NOT NULL,
    porcentajenaturalezagasto numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.naturalezagasto OWNER TO postgres;

--
-- TOC entry 536 (class 1255 OID 131950)
-- Name: obtener_naturalezagasto_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_naturalezagasto_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.naturalezagasto
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.naturalezagasto
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.naturalezagasto t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_naturalezagasto_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 317 (class 1259 OID 74136)
-- Name: operacionesbienesrealizables; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.operacionesbienesrealizables (
    id_load_local bigint NOT NULL,
    idbienrealizable character varying(50) NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.operacionesbienesrealizables OWNER TO postgres;

--
-- TOC entry 458 (class 1255 OID 131951)
-- Name: obtener_operacionesbienesrealizables_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_operacionesbienesrealizables_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.operacionesbienesrealizables
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.operacionesbienesrealizables
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.operacionesbienesrealizables t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_operacionesbienesrealizables_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 315 (class 1259 OID 74114)
-- Name: operacionescompradas; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.operacionescompradas (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersonaentidadoperacion character varying(2) NOT NULL,
    identidadoperacioncomprada character varying(50) NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudorcomprada character varying(50) NOT NULL,
    idoperacioncreditocomprada character varying(50) NOT NULL,
    fechadesembolsodeudor date NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.operacionescompradas OWNER TO postgres;

--
-- TOC entry 511 (class 1255 OID 131952)
-- Name: obtener_operacionescompradas_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_operacionescompradas_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.operacionescompradas
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.operacionescompradas
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.operacionescompradas t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_operacionescompradas_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 359 (class 1259 OID 123198)
-- Name: operacionescredito; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.operacionescredito (
    id_load_local bigint NOT NULL,
    "TipoOperacionSFN" numeric(1,0) NOT NULL,
    "TipoPersonaDeudor" numeric(2,0) NOT NULL,
    "IdDeudor" character varying(30) NOT NULL,
    "IdOperacionCredito" character varying(25) NOT NULL,
    "IdLineaCredito" character varying(25),
    "IndicadorOperacionModificada" character varying(1),
    "IndicadorPresentaCodeudores" character varying(1),
    "TipoEnfoque" numeric(2,0),
    "TipoSegmento" numeric(2,0),
    "CodigoEtapa" numeric(2,0),
    "CodigoCategoriaRiesgo" numeric(2,0),
    "TasaIncumplimiento" numeric(5,2),
    "LGDMinimoCombinado" numeric(5,2),
    "LGDPromedio" numeric(5,2),
    "LGDRegulatorio" numeric(5,2),
    "TipoOperacion" numeric(3,0) NOT NULL,
    "TipoCatalogoSUGEF" numeric(3,0) NOT NULL,
    "CodigoPaisDestinoCredito" character varying(4),
    "CodigoProvinciaDestinoCredito" numeric(2,0),
    "CodigoCantonDestinoCredito" numeric(2,0),
    "CodigoDistritoDestinoCredito" numeric(4,0),
    "CodigoProvinciaDependenciaCredito" numeric(2,0),
    "CodigoCantonDependenciaCredito" numeric(2,0),
    "TipoCarteraCrediticia" numeric(2,0) NOT NULL,
    "TipoEstadoOperacionCrediticia" numeric(3,0),
    "DiasMaximaMorosidad" numeric(4,0) NOT NULL,
    "MontoFormalizadoOperacionCrediticia" numeric(22,2),
    "TipoMonedaOperacion" numeric(6,0) NOT NULL,
    "MontoOperacionAutorizado" numeric(22,2) NOT NULL,
    "CuentaContablePrincipal" numeric(15,0),
    "SaldoPrincipalOperacionCrediticia" numeric NOT NULL,
    "CuentaContablePrincipalConDepositoPrevio" numeric(15,0),
    "SaldoPrincipalConDepositoPrevio" numeric(22,2) NOT NULL,
    "CuentaContableProductosPorCobrar" numeric(15,0),
    "SaldoProductosPorCobrar" numeric(22,2) NOT NULL,
    "CuentaContablePorDesembolsarConCompromiso" numeric(15,0),
    "SaldoPorDesembolsarConCompromiso" numeric(22,2) NOT NULL,
    "CuentaContableComisiones" numeric(15,0),
    "SaldoComisionesOperacionesContingentes" numeric(22,2) NOT NULL,
    "CuentaContableSaldoPendienteUtilizacionSinCompromiso" numeric(15,0),
    "SaldoPendienteUtilizacionSinCompromiso" numeric(22,2),
    "MontoDesembolsado" numeric(22,2) NOT NULL,
    "FechaFormalizacion" date NOT NULL,
    "FechaVencimiento" date NOT NULL,
    "EAD" numeric(22,2) NOT NULL,
    "SaldoOperacionSegmentacion" numeric(22,2),
    "TipoFrecuenciaPagoActualPrincipal" numeric(2,0),
    "TipoFrecuenciaPagoActualIntereses" numeric(2,0),
    "FechaVencimientoPeriodoGraciaPrincipal" date,
    "TasaLey7472" numeric(10,7),
    "TasaInteresNominalVigente" numeric(5,2),
    "IndicadorTipoTasa" character varying(2),
    "FactorDeTiempoCalculoIntereses" character varying(1),
    "IndicadorFormaPagoVigentePrincipal" character varying(1),
    "IndicadorFormaPagoVigenteIntereses" character varying(1),
    "FechaCorteOperacion" date,
    "FechaProximoPagoPrincipal" date,
    "FechaProximoPagoIntereses" date,
    "FechaAmortizacionHasta" date,
    "FechaInteresHasta" date,
    "FechaPagoPactadoPrincipal" date,
    "FechaPagoPactadoIntereses" date,
    "PlazoOperacionDias" numeric(6,0) NOT NULL,
    "TipoCuotaPrincipal" numeric(2,0),
    "MontoCuotaPrincipalActual" numeric(22,2),
    "MontoCuotaInteresesActual" numeric(22,2),
    "IndicadorOperacionNueva" character varying(1),
    "MontoRecuperacionPrincipal" numeric(22,2) NOT NULL,
    "MontoOtrosAumentosDePrincipal" numeric(22,2) NOT NULL,
    "MontoOtrasDisminucionesDePrincipal" numeric(22,2) NOT NULL,
    "IndicadorBacktoBack" character varying(1) NOT NULL,
    "IndicadorCreditoSindicado" character varying(1) NOT NULL,
    "IndicadorOperacionEspecial" character varying(1) NOT NULL,
    "TipoMotivoOperacionEspecial" numeric(3,0),
    "CodigoClausulaLimiteCredito" numeric(2,0),
    "FechaCambioTipoTasa" date,
    "TipoFrecuenciaAjusteTasaInteresVariable" numeric(2,0),
    "TipoParametroReferenciaTasaInteresVariable" numeric(3,0),
    "PorcentajeComponenteVariableTasaInteresVariable" numeric(5,2),
    "PorcentajeComponenteFijoTasaInteresVariable" numeric(5,2),
    "LimiteInferiorTasaInteresVariable" numeric(5,2),
    "LimiteSuperiorTasaInteresVariable" numeric(5,2),
    "MontoEstimacionEspecifica" numeric(22,2),
    "MontoEstimacionAvales" numeric(22,2),
    "TipoProgramaAutorizadoSBD" numeric(5,0) NOT NULL,
    "IndicadorCreditoGrupalSolidarioSBD" numeric(1,0) NOT NULL,
    "TipoSectorPrioritarioDeudorSBD" numeric(2,0) NOT NULL,
    "IdFondeadorSBD" character varying(30),
    "TipoPersonaIdFondeadorSBD" numeric(2,0),
    "IndicadorOperacionCedidaEnGarantia" character varying(1) NOT NULL,
    "PorcentajePonderadorSPD" numeric(5,2) NOT NULL,
    "PorcentajePonderadorSPC" numeric(5,2) NOT NULL,
    "PorcentajeIndicadorLTV" numeric(5,2),
    "IndicadorCambioClimatico" character varying(1) NOT NULL,
    "TipoClasificacionRiesgoClimatico" numeric(2,0),
    "TipoMetodologiaClimatica" numeric(2,0),
    "TipoPotencialidadImpactoClimatico" numeric(2,0),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.operacionescredito OWNER TO postgres;

--
-- TOC entry 538 (class 1255 OID 131953)
-- Name: obtener_operacionescredito_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_operacionescredito_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.operacionescredito
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.operacionescredito
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY
    SELECT *
    FROM feguslocal.operacionescredito oc
    WHERE oc.id_load_local = p_id_load_local
    AND oc.seq > p_last_seq
    ORDER BY oc.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_operacionescredito_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 324 (class 1259 OID 74213)
-- Name: operacionesnoreportadas; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.operacionesnoreportadas (
    id_load_local bigint NOT NULL,
    tipopersona character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacion character varying(50) NOT NULL,
    motivoliquidacion character varying(10) NOT NULL,
    fechaliquidacion date NOT NULL,
    saldoprincipalliquidado numeric(18,2) NOT NULL,
    saldoproductosliquidado numeric(18,2) NOT NULL,
    idoperacionnueva character varying(50),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.operacionesnoreportadas OWNER TO postgres;

--
-- TOC entry 531 (class 1255 OID 131954)
-- Name: obtener_operacionesnoreportadas_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_operacionesnoreportadas_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.operacionesnoreportadas
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.operacionesnoreportadas
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.operacionesnoreportadas t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_operacionesnoreportadas_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 308 (class 1259 OID 74036)
-- Name: origenrecursos; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.origenrecursos (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipoorigenrecursos character varying(10) NOT NULL,
    porcentajeorigenrecursos numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone,
    seq bigint NOT NULL
);


ALTER TABLE feguslocal.origenrecursos OWNER TO postgres;

--
-- TOC entry 515 (class 1255 OID 131955)
-- Name: obtener_origenrecursos_lista(bigint, bigint); Type: FUNCTION; Schema: feguslocal; Owner: postgres
--

CREATE FUNCTION feguslocal.obtener_origenrecursos_lista(p_id_load_local bigint, p_last_seq bigint DEFAULT 0) RETURNS SETOF feguslocal.origenrecursos
    LANGUAGE plpgsql
    AS $$
BEGIN

	--Se actualiza cualquier registro donde la columna id_load_local
	Update feguslocal.origenrecursos
	set id_load_local = p_id_load_local
	where id_load_local = -1;

    RETURN QUERY SELECT * FROM feguslocal.origenrecursos t
    WHERE t.id_load_local = p_id_load_local
    AND t.seq > p_last_seq
    ORDER BY t.seq;
END;
$$;


ALTER FUNCTION feguslocal.obtener_origenrecursos_lista(p_id_load_local bigint, p_last_seq bigint) OWNER TO postgres;

--
-- TOC entry 429 (class 1259 OID 131683)
-- Name: actividadeconomica_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.actividadeconomica ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.actividadeconomica_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 430 (class 1259 OID 131688)
-- Name: bienesrealizables_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.bienesrealizables ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.bienesrealizables_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 431 (class 1259 OID 131693)
-- Name: bienesrealizablesnoreportados_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.bienesrealizablesnoreportados ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.bienesrealizablesnoreportados_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 432 (class 1259 OID 131698)
-- Name: cambioclimatico_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.cambioclimatico ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.cambioclimatico_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 433 (class 1259 OID 131703)
-- Name: codeudores_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.codeudores ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.codeudores_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 434 (class 1259 OID 131708)
-- Name: creditossindicados_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.creditossindicados ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.creditossindicados_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 435 (class 1259 OID 131713)
-- Name: cuentasporcobrarnosasociadas_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.cuentasporcobrarnosasociadas ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.cuentasporcobrarnosasociadas_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 436 (class 1259 OID 131718)
-- Name: cuentasxcobrar_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.cuentasxcobrar ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.cuentasxcobrar_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 437 (class 1259 OID 131723)
-- Name: cuotasatrasadas_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.cuotasatrasadas ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.cuotasatrasadas_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 438 (class 1259 OID 131728)
-- Name: deudores_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.deudores ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.deudores_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 350 (class 1259 OID 90373)
-- Name: fe_box_data_load; Type: TABLE; Schema: feguslocal; Owner: postgres
--

CREATE TABLE feguslocal.fe_box_data_load (
    id_cliente integer NOT NULL,
    id_load bigint,
    id_load_local bigint NOT NULL,
    state_code character varying(30),
    is_active character varying(1),
    asofdate timestamp without time zone,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);


ALTER TABLE feguslocal.fe_box_data_load OWNER TO postgres;

--
-- TOC entry 5510 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fe_box_data_load.id_cliente; Type: COMMENT; Schema: feguslocal; Owner: postgres
--

COMMENT ON COLUMN feguslocal.fe_box_data_load.id_cliente IS 'Identificacion de la entidad financiera';


--
-- TOC entry 5511 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fe_box_data_load.id_load; Type: COMMENT; Schema: feguslocal; Owner: postgres
--

COMMENT ON COLUMN feguslocal.fe_box_data_load.id_load IS 'Consecutivo numerico que identifica la caja (box) de datos cargados';


--
-- TOC entry 5512 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fe_box_data_load.id_load_local; Type: COMMENT; Schema: feguslocal; Owner: postgres
--

COMMENT ON COLUMN feguslocal.fe_box_data_load.id_load_local IS 'Consecutivo numerico dado por la entidad financiera';


--
-- TOC entry 5513 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fe_box_data_load.state_code; Type: COMMENT; Schema: feguslocal; Owner: postgres
--

COMMENT ON COLUMN feguslocal.fe_box_data_load.state_code IS 'Este representa el estado en el que se encuentra el proceso de gestion sobre los datos cargados de este id_load';


--
-- TOC entry 5514 (class 0 OID 0)
-- Dependencies: 350
-- Name: COLUMN fe_box_data_load.is_active; Type: COMMENT; Schema: feguslocal; Owner: postgres
--

COMMENT ON COLUMN feguslocal.fe_box_data_load.is_active IS 'Este representa el estado activo (A) o inactivo (I) del id_load';


--
-- TOC entry 349 (class 1259 OID 90372)
-- Name: fe_box_data_load_id_load_local_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.fe_box_data_load ALTER COLUMN id_load_local ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.fe_box_data_load_id_load_local_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 439 (class 1259 OID 131736)
-- Name: fideicomiso_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.fideicomiso ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.fideicomiso_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 440 (class 1259 OID 131741)
-- Name: garantiascartascredito_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.garantiascartascredito ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.garantiascartascredito_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 441 (class 1259 OID 131747)
-- Name: garantiasfacturascedidas_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.garantiasfacturascedidas ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.garantiasfacturascedidas_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 442 (class 1259 OID 131753)
-- Name: garantiasfiduciarias_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.garantiasfiduciarias ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.garantiasfiduciarias_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 443 (class 1259 OID 131759)
-- Name: garantiasmobiliarias_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.garantiasmobiliarias ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.garantiasmobiliarias_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 444 (class 1259 OID 131764)
-- Name: garantiasoperacion_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.garantiasoperacion ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.garantiasoperacion_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 445 (class 1259 OID 131769)
-- Name: garantiaspolizas_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.garantiaspolizas ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.garantiaspolizas_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 446 (class 1259 OID 131775)
-- Name: garantiasreales_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.garantiasreales ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.garantiasreales_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 447 (class 1259 OID 131781)
-- Name: garantiasvalores_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.garantiasvalores ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.garantiasvalores_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 448 (class 1259 OID 131787)
-- Name: gravamenes_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.gravamenes ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.gravamenes_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 449 (class 1259 OID 131792)
-- Name: ingresodeudores_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.ingresodeudores ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.ingresodeudores_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 450 (class 1259 OID 131797)
-- Name: modificacion_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.modificacion ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.modificacion_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 451 (class 1259 OID 131802)
-- Name: naturalezagasto_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.naturalezagasto ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.naturalezagasto_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 452 (class 1259 OID 131807)
-- Name: operacionesbienesrealizables_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.operacionesbienesrealizables ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.operacionesbienesrealizables_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 453 (class 1259 OID 131812)
-- Name: operacionescompradas_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.operacionescompradas ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.operacionescompradas_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 454 (class 1259 OID 131817)
-- Name: operacionescredito_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.operacionescredito ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.operacionescredito_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 455 (class 1259 OID 131823)
-- Name: operacionesnoreportadas_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.operacionesnoreportadas ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.operacionesnoreportadas_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 456 (class 1259 OID 131828)
-- Name: origenrecursos_seq_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

ALTER TABLE feguslocal.origenrecursos ALTER COLUMN seq ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.origenrecursos_seq_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 329 (class 1259 OID 74328)
-- Name: seq_deudor; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

CREATE SEQUENCE feguslocal.seq_deudor
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE feguslocal.seq_deudor OWNER TO postgres;

--
-- TOC entry 330 (class 1259 OID 74329)
-- Name: seq_garantia; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

CREATE SEQUENCE feguslocal.seq_garantia
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE feguslocal.seq_garantia OWNER TO postgres;

--
-- TOC entry 328 (class 1259 OID 74327)
-- Name: seq_operacion; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--

CREATE SEQUENCE feguslocal.seq_operacion
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE feguslocal.seq_operacion OWNER TO postgres;

--
-- TOC entry 5331 (class 2606 OID 74242)
-- Name: deudores deudores_pkey; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.deudores
    ADD CONSTRAINT deudores_pkey PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor);


--
-- TOC entry 5334 (class 2606 OID 90380)
-- Name: fe_box_data_load fe_box_data_load_id_load_key; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.fe_box_data_load
    ADD CONSTRAINT fe_box_data_load_id_load_key UNIQUE (id_load);


--
-- TOC entry 5297 (class 2606 OID 74052)
-- Name: actividadeconomica pk_actividadeconomica; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.actividadeconomica
    ADD CONSTRAINT pk_actividadeconomica PRIMARY KEY (id_load_local, idoperacioncredito, tipoactividadeconomica);


--
-- TOC entry 5319 (class 2606 OID 74174)
-- Name: bienesrealizables pk_bienesrealizables; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.bienesrealizables
    ADD CONSTRAINT pk_bienesrealizables PRIMARY KEY (id_load_local, idbienrealizable);


--
-- TOC entry 5317 (class 2606 OID 74163)
-- Name: bienesrealizablesnoreportados pk_bienesrealizablesnoreportados; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.bienesrealizablesnoreportados
    ADD CONSTRAINT pk_bienesrealizablesnoreportados PRIMARY KEY (id_load_local, idbienrealizable);


--
-- TOC entry 5311 (class 2606 OID 74130)
-- Name: cambioclimatico pk_cambioclimatico; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.cambioclimatico
    ADD CONSTRAINT pk_cambioclimatico PRIMARY KEY (id_load_local, idoperacioncredito);


--
-- TOC entry 5305 (class 2606 OID 74097)
-- Name: codeudores pk_codeudores; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.codeudores
    ADD CONSTRAINT pk_codeudores PRIMARY KEY (id_load_local, idoperacioncredito, idcodeudor, tipopersonacodeudor);


--
-- TOC entry 5303 (class 2606 OID 74086)
-- Name: creditossindicados pk_creditossindicados; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.creditossindicados
    ADD CONSTRAINT pk_creditossindicados PRIMARY KEY (id_load_local, idoperacioncredito, tipopersona, identidadcreditosindicado, idoperacioncreditoentidadcreditosindicado);


--
-- TOC entry 5323 (class 2606 OID 74196)
-- Name: cuentasporcobrarnosasociadas pk_cuentasporcobrarnosasociadas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.cuentasporcobrarnosasociadas
    ADD CONSTRAINT pk_cuentasporcobrarnosasociadas PRIMARY KEY (id_load_local, idoperacioncredito);


--
-- TOC entry 5301 (class 2606 OID 74074)
-- Name: cuentasxcobrar pk_cuentasxcobrar; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.cuentasxcobrar
    ADD CONSTRAINT pk_cuentasxcobrar PRIMARY KEY (id_load_local, idoperacioncredito, idcuentacobrarasociada);


--
-- TOC entry 5325 (class 2606 OID 74207)
-- Name: cuotasatrasadas pk_cuotasatrasadas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.cuotasatrasadas
    ADD CONSTRAINT pk_cuotasatrasadas PRIMARY KEY (id_load_local, idoperacioncredito, tipocuota, numerocuotaatrasada);


--
-- TOC entry 5341 (class 2606 OID 90378)
-- Name: fe_box_data_load pk_fe_box_data_load; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.fe_box_data_load
    ADD CONSTRAINT pk_fe_box_data_load PRIMARY KEY (id_cliente, id_load_local);


--
-- TOC entry 5315 (class 2606 OID 74152)
-- Name: fideicomiso pk_fideicomiso; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.fideicomiso
    ADD CONSTRAINT pk_fideicomiso PRIMARY KEY (id_load_local, idfideicomisogarantia);


--
-- TOC entry 5359 (class 2606 OID 123153)
-- Name: garantiascartascredito pk_garantiascartascredito; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.garantiascartascredito
    ADD CONSTRAINT pk_garantiascartascredito PRIMARY KEY (id_load_local, idgarantiacartacredito);


--
-- TOC entry 5347 (class 2606 OID 123125)
-- Name: garantiasfacturascedidas pk_garantiasfacturascedidas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.garantiasfacturascedidas
    ADD CONSTRAINT pk_garantiasfacturascedidas PRIMARY KEY (id_load_local, idgarantiafacturacedida);


--
-- TOC entry 5350 (class 2606 OID 123132)
-- Name: garantiasfiduciarias pk_garantiasfiduciarias; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.garantiasfiduciarias
    ADD CONSTRAINT pk_garantiasfiduciarias PRIMARY KEY (id_load_local, idgarantiafiduciaria);


--
-- TOC entry 5329 (class 2606 OID 74229)
-- Name: garantiasmobiliarias pk_garantiasmobiliarias; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.garantiasmobiliarias
    ADD CONSTRAINT pk_garantiasmobiliarias PRIMARY KEY (id_load_local, idgarantiamobiliaria);


--
-- TOC entry 5291 (class 2606 OID 74019)
-- Name: garantiasoperacion pk_garantiasoperacion; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.garantiasoperacion
    ADD CONSTRAINT pk_garantiasoperacion PRIMARY KEY (id_load_local, idoperacioncredito, tipopersonadeudor, iddeudor, idgarantia, tipomitigador, tipodocumentolegal);


--
-- TOC entry 5344 (class 2606 OID 123111)
-- Name: garantiaspolizas pk_garantiaspolizas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.garantiaspolizas
    ADD CONSTRAINT pk_garantiaspolizas PRIMARY KEY (id_load_local, idgarantia, tipogarantia, tipobiengarantia, tipopoliza, fechavencimientopoliza);


--
-- TOC entry 5353 (class 2606 OID 123139)
-- Name: garantiasreales pk_garantiasreales; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.garantiasreales
    ADD CONSTRAINT pk_garantiasreales PRIMARY KEY (id_load_local, idgarantiareal);


--
-- TOC entry 5356 (class 2606 OID 123146)
-- Name: garantiasvalores pk_garantiasvalores; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.garantiasvalores
    ADD CONSTRAINT pk_garantiasvalores PRIMARY KEY (id_load_local, idgarantiavalor);


--
-- TOC entry 5321 (class 2606 OID 74185)
-- Name: gravamenes pk_gravamenes; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.gravamenes
    ADD CONSTRAINT pk_gravamenes PRIMARY KEY (id_load_local, idoperacioncredito, idgarantia, tipomitigador, tipodocumentolegal, tipogradogravamenes, tipopersonaacreedor, idacreedor);


--
-- TOC entry 5293 (class 2606 OID 74030)
-- Name: ingresodeudores pk_ingresodeudores; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.ingresodeudores
    ADD CONSTRAINT pk_ingresodeudores PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor, tipoingresodeudor, tipomonedaingreso);


--
-- TOC entry 5307 (class 2606 OID 74108)
-- Name: modificacion pk_modificacion; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.modificacion
    ADD CONSTRAINT pk_modificacion PRIMARY KEY (id_load_local, idoperacioncredito, tipomodificacion);


--
-- TOC entry 5299 (class 2606 OID 74063)
-- Name: naturalezagasto pk_naturalezagasto; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.naturalezagasto
    ADD CONSTRAINT pk_naturalezagasto PRIMARY KEY (id_load_local, idoperacioncredito, tiponaturalezagasto);


--
-- TOC entry 5313 (class 2606 OID 74141)
-- Name: operacionesbienesrealizables pk_operacionesbienesrealizables; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.operacionesbienesrealizables
    ADD CONSTRAINT pk_operacionesbienesrealizables PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor, idoperacioncredito, idbienrealizable);


--
-- TOC entry 5309 (class 2606 OID 74119)
-- Name: operacionescompradas pk_operacionescompradas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.operacionescompradas
    ADD CONSTRAINT pk_operacionescompradas PRIMARY KEY (id_load_local, idoperacioncredito, tipopersonaentidadoperacion, identidadoperacioncomprada, tipopersonadeudor, iddeudorcomprada, idoperacioncreditocomprada);


--
-- TOC entry 5327 (class 2606 OID 74218)
-- Name: operacionesnoreportadas pk_operacionesnoreportadas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.operacionesnoreportadas
    ADD CONSTRAINT pk_operacionesnoreportadas PRIMARY KEY (id_load_local, idoperacion);


--
-- TOC entry 5295 (class 2606 OID 74041)
-- Name: origenrecursos pk_origenrecursos; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--

ALTER TABLE ONLY feguslocal.origenrecursos
    ADD CONSTRAINT pk_origenrecursos PRIMARY KEY (id_load_local, idoperacioncredito, tipoorigenrecursos);


--
-- TOC entry 5332 (class 1259 OID 106717)
-- Name: idx_deudores_id_load_local_m1; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_deudores_id_load_local_m1 ON feguslocal.deudores USING btree (id_load_local) WHERE (id_load_local = '-1'::integer);


--
-- TOC entry 5335 (class 1259 OID 90381)
-- Name: idx_fe_box_data_load_1; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_fe_box_data_load_1 ON feguslocal.fe_box_data_load USING btree (id_cliente);


--
-- TOC entry 5336 (class 1259 OID 90382)
-- Name: idx_fe_box_data_load_2; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_fe_box_data_load_2 ON feguslocal.fe_box_data_load USING btree (id_cliente, id_load);


--
-- TOC entry 5337 (class 1259 OID 90383)
-- Name: idx_fe_box_data_load_3; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_fe_box_data_load_3 ON feguslocal.fe_box_data_load USING btree (id_cliente, is_active);


--
-- TOC entry 5338 (class 1259 OID 90384)
-- Name: idx_fe_box_data_load_4; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_fe_box_data_load_4 ON feguslocal.fe_box_data_load USING btree (created_at_utc);


--
-- TOC entry 5339 (class 1259 OID 90385)
-- Name: idx_fe_box_data_load_5; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_fe_box_data_load_5 ON feguslocal.fe_box_data_load USING btree (updated_at_utc);


--
-- TOC entry 5357 (class 1259 OID 123154)
-- Name: idx_garantiascartascredito_id_load_local_m1; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_garantiascartascredito_id_load_local_m1 ON feguslocal.garantiascartascredito USING btree (id_load_local) WHERE (id_load_local = '-1'::integer);


--
-- TOC entry 5345 (class 1259 OID 123126)
-- Name: idx_garantiasfacturascedidas_id_load_local_m1; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_garantiasfacturascedidas_id_load_local_m1 ON feguslocal.garantiasfacturascedidas USING btree (id_load_local) WHERE (id_load_local = '-1'::integer);


--
-- TOC entry 5348 (class 1259 OID 123133)
-- Name: idx_garantiasfiduciarias_id_load_local_m1; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_garantiasfiduciarias_id_load_local_m1 ON feguslocal.garantiasfiduciarias USING btree (id_load_local) WHERE (id_load_local = '-1'::integer);


--
-- TOC entry 5342 (class 1259 OID 123112)
-- Name: idx_garantiaspolizas_id_load_local_m1; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_garantiaspolizas_id_load_local_m1 ON feguslocal.garantiaspolizas USING btree (id_load_local) WHERE (id_load_local = '-1'::integer);


--
-- TOC entry 5351 (class 1259 OID 123140)
-- Name: idx_garantiasreales_id_load_local_m1; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_garantiasreales_id_load_local_m1 ON feguslocal.garantiasreales USING btree (id_load_local) WHERE (id_load_local = '-1'::integer);


--
-- TOC entry 5354 (class 1259 OID 123147)
-- Name: idx_garantiasvalores_id_load_local_m1; Type: INDEX; Schema: feguslocal; Owner: postgres
--

CREATE INDEX idx_garantiasvalores_id_load_local_m1 ON feguslocal.garantiasvalores USING btree (id_load_local) WHERE (id_load_local = '-1'::integer);


-- Completed on 2026-05-14 08:40:17

--
-- PostgreSQL database dump complete
--

\unrestrict IK1FtjuXtaRLlBcUvb7TPJqSAmKu2KarkayQnMQdKHBTLoyLC31cJNJBJfUsSRS

