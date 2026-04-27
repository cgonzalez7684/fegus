--
-- PostgreSQL database dump
--
\restrict AiKevxO16etkSJ3HHdrahbjPW9ysdn88uLTyWtgO5kEE8J7ZgH7IXh6CxQKt4xf
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
-- Name: gravamenes; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.gravamenes (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    idgarantia character varying(50) NOT NULL,
    tipomitigador character varying(10) NOT NULL,
    tipodocumentolegal character varying(10) NOT NULL,
    tipogradogravamenes character varying(10) NOT NULL,
    tipopersonaacreedor character varying(2) NOT NULL,
    idacreedor character varying(50) NOT NULL,
    montogradogravamen numeric(18,2) NOT NULL,
    tipomonedamonto character varying(5) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.gravamenes OWNER TO postgres;
--
-- Name: gravamenes pk_gravamenes; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.gravamenes
    ADD CONSTRAINT pk_gravamenes PRIMARY KEY (id_load_local, idoperacioncredito, idgarantia, tipomitigador, tipodocumentolegal, tipogradogravamenes, tipopersonaacreedor, idacreedor);
--
-- PostgreSQL database dump complete
--
\unrestrict AiKevxO16etkSJ3HHdrahbjPW9ysdn88uLTyWtgO5kEE8J7ZgH7IXh6CxQKt4xf
