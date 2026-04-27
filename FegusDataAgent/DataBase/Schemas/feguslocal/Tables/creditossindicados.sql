--
-- PostgreSQL database dump
--
\restrict 4yQnlRTFUjSuA6ld1nvmyQd7KwgfyJOcSCPSvpoagoE3rty2MCZ4wzqNod2cFSZ
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
-- Name: creditossindicados; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.creditossindicados (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersona character varying(2) NOT NULL,
    identidadcreditosindicado character varying(50) NOT NULL,
    idoperacioncreditoentidadcreditosindicado character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.creditossindicados OWNER TO postgres;
--
-- Name: creditossindicados pk_creditossindicados; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.creditossindicados
    ADD CONSTRAINT pk_creditossindicados PRIMARY KEY (id_load_local, idoperacioncredito, tipopersona, identidadcreditosindicado, idoperacioncreditoentidadcreditosindicado);
--
-- PostgreSQL database dump complete
--
\unrestrict 4yQnlRTFUjSuA6ld1nvmyQd7KwgfyJOcSCPSvpoagoE3rty2MCZ4wzqNod2cFSZ
