--
-- PostgreSQL database dump
--
\restrict wHb9krdhH3p6lduS52UCMFfygvdIKgnagRFDFPOpszYZotyibzW6Riks66bh8eL
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
-- Name: operacionesbienesrealizables; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.operacionesbienesrealizables (
    id_load_local bigint NOT NULL,
    idbienrealizable character varying(50) NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.operacionesbienesrealizables OWNER TO postgres;
--
-- Name: operacionesbienesrealizables pk_operacionesbienesrealizables; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.operacionesbienesrealizables
    ADD CONSTRAINT pk_operacionesbienesrealizables PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor, idoperacioncredito, idbienrealizable);
--
-- PostgreSQL database dump complete
--
\unrestrict wHb9krdhH3p6lduS52UCMFfygvdIKgnagRFDFPOpszYZotyibzW6Riks66bh8eL
