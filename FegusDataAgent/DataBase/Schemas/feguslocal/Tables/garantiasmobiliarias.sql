--
-- PostgreSQL database dump
--
\restrict m4rAcSP2tsAc1MYvRbOADxWmHxeNTfH5Ve8v7TXcsRcWegADudbin4EfAB30R9U
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
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.garantiasmobiliarias OWNER TO postgres;
--
-- Name: garantiasmobiliarias pk_garantiasmobiliarias; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.garantiasmobiliarias
    ADD CONSTRAINT pk_garantiasmobiliarias PRIMARY KEY (id_load_local, idgarantiamobiliaria);
--
-- PostgreSQL database dump complete
--
\unrestrict m4rAcSP2tsAc1MYvRbOADxWmHxeNTfH5Ve8v7TXcsRcWegADudbin4EfAB30R9U
