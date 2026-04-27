--
-- PostgreSQL database dump
--
\restrict HwHlHEdh5aow1hyXs7oON9lwB1zv5sg7DMy7kXeSBp8b7upMAGPEnTnKHQdVPqX
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
-- Name: codeudores; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.codeudores (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersonacodeudor character varying(2) NOT NULL,
    idcodeudor character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.codeudores OWNER TO postgres;
--
-- Name: codeudores pk_codeudores; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.codeudores
    ADD CONSTRAINT pk_codeudores PRIMARY KEY (id_load_local, idoperacioncredito, idcodeudor, tipopersonacodeudor);
--
-- PostgreSQL database dump complete
--
\unrestrict HwHlHEdh5aow1hyXs7oON9lwB1zv5sg7DMy7kXeSBp8b7upMAGPEnTnKHQdVPqX
