--
-- PostgreSQL database dump
--
\restrict VJKzqgIlRJnwhUAGyVrkQKzshUnvLiog8HxsnWUC3qZMowBcD3OfGe7zXCrgDOu
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
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.operacionescompradas OWNER TO postgres;
--
-- Name: operacionescompradas pk_operacionescompradas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.operacionescompradas
    ADD CONSTRAINT pk_operacionescompradas PRIMARY KEY (id_load_local, idoperacioncredito, tipopersonaentidadoperacion, identidadoperacioncomprada, tipopersonadeudor, iddeudorcomprada, idoperacioncreditocomprada);
--
-- PostgreSQL database dump complete
--
\unrestrict VJKzqgIlRJnwhUAGyVrkQKzshUnvLiog8HxsnWUC3qZMowBcD3OfGe7zXCrgDOu
