--
-- PostgreSQL database dump
--
\restrict Fo0JioecNeB7uTzfVRlBUrX23U5wMfc5GTYufM8d2NArPa2ijaJuV7vTIbfeexy
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
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.bienesrealizables OWNER TO postgres;
--
-- Name: bienesrealizables pk_bienesrealizables; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.bienesrealizables
    ADD CONSTRAINT pk_bienesrealizables PRIMARY KEY (id_load_local, idbienrealizable);
--
-- PostgreSQL database dump complete
--
\unrestrict Fo0JioecNeB7uTzfVRlBUrX23U5wMfc5GTYufM8d2NArPa2ijaJuV7vTIbfeexy
