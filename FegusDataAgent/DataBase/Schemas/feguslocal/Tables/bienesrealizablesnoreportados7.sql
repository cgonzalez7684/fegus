--
-- PostgreSQL database dump
--
\restrict kLZuzACHPhIDqfidxz7WebzAJ6JDhKHmzgauL8vSSnjZGzCSVAOj1KMovvzvPKU
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
-- Name: bienesrealizablesnoreportados7; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.bienesrealizablesnoreportados7 (
    id_load_local bigint NOT NULL,
    idbienrealizable character varying(50) NOT NULL,
    indicadorgarantia character varying(1) NOT NULL,
    idgarantia character varying(50) NOT NULL,
    idbien character varying(50) NOT NULL,
    tipobien character varying(10) NOT NULL,
    tipomotivobienrealizablenoreportado character varying(10) NOT NULL,
    ultimovalorcontable numeric(18,2) NOT NULL,
    valorrecuperadoneto numeric(18,2) NOT NULL,
    idoperacioncreditofinanciamiento character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.bienesrealizablesnoreportados7 OWNER TO postgres;
--
-- Name: bienesrealizablesnoreportados7 pk_bienesrealizablesnoreportados7; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.bienesrealizablesnoreportados7
    ADD CONSTRAINT pk_bienesrealizablesnoreportados7 PRIMARY KEY (id_load_local, idbienrealizable);
--
-- PostgreSQL database dump complete
--
\unrestrict kLZuzACHPhIDqfidxz7WebzAJ6JDhKHmzgauL8vSSnjZGzCSVAOj1KMovvzvPKU
