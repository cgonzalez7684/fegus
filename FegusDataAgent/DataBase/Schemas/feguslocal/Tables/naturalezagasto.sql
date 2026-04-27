--
-- PostgreSQL database dump
--
\restrict HE9OMQhSvX0oa8uG4o1pZrrjggvVqytIBnS2bDMTe43g0lHdkaz6GSiU4TYmjSg
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
-- Name: naturalezagasto; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.naturalezagasto (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tiponaturalezagasto character varying(10) NOT NULL,
    porcentajenaturalezagasto numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.naturalezagasto OWNER TO postgres;
--
-- Name: naturalezagasto pk_naturalezagasto; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.naturalezagasto
    ADD CONSTRAINT pk_naturalezagasto PRIMARY KEY (id_load_local, idoperacioncredito, tiponaturalezagasto);
--
-- PostgreSQL database dump complete
--
\unrestrict HE9OMQhSvX0oa8uG4o1pZrrjggvVqytIBnS2bDMTe43g0lHdkaz6GSiU4TYmjSg
