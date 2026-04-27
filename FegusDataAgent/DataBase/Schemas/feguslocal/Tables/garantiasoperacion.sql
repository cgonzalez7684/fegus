--
-- PostgreSQL database dump
--
\restrict 3kiHvSph5XI4sHD2Y3eYnPC1O6B2NMF11kanhZ2aweTIfHsViYNNwS1p3eq2hhV
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
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.garantiasoperacion OWNER TO postgres;
--
-- Name: garantiasoperacion pk_garantiasoperacion; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.garantiasoperacion
    ADD CONSTRAINT pk_garantiasoperacion PRIMARY KEY (id_load_local, idoperacioncredito, tipopersonadeudor, iddeudor, idgarantia, tipomitigador, tipodocumentolegal);
--
-- PostgreSQL database dump complete
--
\unrestrict 3kiHvSph5XI4sHD2Y3eYnPC1O6B2NMF11kanhZ2aweTIfHsViYNNwS1p3eq2hhV
