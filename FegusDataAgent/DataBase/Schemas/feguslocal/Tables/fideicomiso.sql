--
-- PostgreSQL database dump
--
\restrict AhORWfqADjfh4nvBnVaePd9tqjhgCxv5i5j0WfqyplhHa9jb1USb74qUwKtQhuy
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
-- Name: fideicomiso; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.fideicomiso (
    id_load_local bigint NOT NULL,
    idfideicomisogarantia character varying(50) NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date NOT NULL,
    valornominalfideicomiso numeric(18,2) NOT NULL,
    tipomonedavalornominalfideicomiso character varying(5) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.fideicomiso OWNER TO postgres;
--
-- Name: fideicomiso pk_fideicomiso; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.fideicomiso
    ADD CONSTRAINT pk_fideicomiso PRIMARY KEY (id_load_local, idfideicomisogarantia);
--
-- PostgreSQL database dump complete
--
\unrestrict AhORWfqADjfh4nvBnVaePd9tqjhgCxv5i5j0WfqyplhHa9jb1USb74qUwKtQhuy
