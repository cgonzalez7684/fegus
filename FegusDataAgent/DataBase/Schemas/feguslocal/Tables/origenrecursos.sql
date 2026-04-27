--
-- PostgreSQL database dump
--
\restrict ElgvCS9Glv2mHwbyZhCke4rOKwebWpgsbXPcQCVG9CsSf4qHmmFtWbtdIGpaspQ
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
-- Name: origenrecursos; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.origenrecursos (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipoorigenrecursos character varying(10) NOT NULL,
    porcentajeorigenrecursos numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.origenrecursos OWNER TO postgres;
--
-- Name: origenrecursos pk_origenrecursos; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.origenrecursos
    ADD CONSTRAINT pk_origenrecursos PRIMARY KEY (id_load_local, idoperacioncredito, tipoorigenrecursos);
--
-- PostgreSQL database dump complete
--
\unrestrict ElgvCS9Glv2mHwbyZhCke4rOKwebWpgsbXPcQCVG9CsSf4qHmmFtWbtdIGpaspQ
