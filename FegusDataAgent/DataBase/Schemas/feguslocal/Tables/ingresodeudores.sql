--
-- PostgreSQL database dump
--
\restrict 2kbGyZdWD1ZhlLjXmf4Uqi7jhvzxqIB6OsSjjCheFfMSxEK4WGHEVggymtleJgF
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
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.ingresodeudores OWNER TO postgres;
--
-- Name: ingresodeudores pk_ingresodeudores; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.ingresodeudores
    ADD CONSTRAINT pk_ingresodeudores PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor, tipoingresodeudor, tipomonedaingreso);
--
-- PostgreSQL database dump complete
--
\unrestrict 2kbGyZdWD1ZhlLjXmf4Uqi7jhvzxqIB6OsSjjCheFfMSxEK4WGHEVggymtleJgF
