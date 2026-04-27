--
-- PostgreSQL database dump
--
\restrict AViutAI3WGVKWFagJ6I905oFU16DGp9h6up2QfciqTtfqZgLbevRQt3gE7a2qXE
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
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.cambioclimatico OWNER TO postgres;
--
-- Name: cambioclimatico pk_cambioclimatico; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.cambioclimatico
    ADD CONSTRAINT pk_cambioclimatico PRIMARY KEY (id_load_local, idoperacioncredito);
--
-- PostgreSQL database dump complete
--
\unrestrict AViutAI3WGVKWFagJ6I905oFU16DGp9h6up2QfciqTtfqZgLbevRQt3gE7a2qXE
