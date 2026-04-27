--
-- PostgreSQL database dump
--
\restrict C5evbWVnn1KZWbHMSDJrEXjZoJKDL03EyzSQaxOcNPG4OJOjWE98182EPjoVjN4
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
-- Name: actividadeconomica; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.actividadeconomica (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipoactividadeconomica character varying(10) NOT NULL,
    porcentajeactividadeconomica numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.actividadeconomica OWNER TO postgres;
--
-- Name: actividadeconomica pk_actividadeconomica; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.actividadeconomica
    ADD CONSTRAINT pk_actividadeconomica PRIMARY KEY (id_load_local, idoperacioncredito, tipoactividadeconomica);
--
-- PostgreSQL database dump complete
--
\unrestrict C5evbWVnn1KZWbHMSDJrEXjZoJKDL03EyzSQaxOcNPG4OJOjWE98182EPjoVjN4
