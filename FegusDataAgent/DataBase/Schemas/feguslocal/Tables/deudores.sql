--
-- PostgreSQL database dump
--
\restrict dCZGJdaG4sdLsXtWxc4VpzFVR93848DJ43wxcigUXP5BcO3PdhEJGggfcwrNUIK
-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.6
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
SET default_tablespace = '';
SET default_table_access_method = heap;
--
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
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.deudores OWNER TO postgres;
--
-- Name: deudores deudores_pkey; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.deudores
    ADD CONSTRAINT deudores_pkey PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor);
--
-- Name: idx_deudores_id_load_local_m1; Type: INDEX; Schema: feguslocal; Owner: postgres
--
CREATE INDEX idx_deudores_id_load_local_m1 ON feguslocal.deudores USING btree (id_load_local) WHERE (id_load_local = '-1'::integer);
--
-- PostgreSQL database dump complete
--
\unrestrict dCZGJdaG4sdLsXtWxc4VpzFVR93848DJ43wxcigUXP5BcO3PdhEJGggfcwrNUIK
