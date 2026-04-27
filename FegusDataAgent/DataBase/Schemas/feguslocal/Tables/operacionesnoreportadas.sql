--
-- PostgreSQL database dump
--
\restrict i0D6TcbkKHrW2D8f4u22Ws1vzVhYMwMOr8dQeO6AqghfZeSCYbYgpI2besrk5hj
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
-- Name: operacionesnoreportadas; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.operacionesnoreportadas (
    id_load_local bigint NOT NULL,
    tipopersona character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacion character varying(50) NOT NULL,
    motivoliquidacion character varying(10) NOT NULL,
    fechaliquidacion date NOT NULL,
    saldoprincipalliquidado numeric(18,2) NOT NULL,
    saldoproductosliquidado numeric(18,2) NOT NULL,
    idoperacionnueva character varying(50),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.operacionesnoreportadas OWNER TO postgres;
--
-- Name: operacionesnoreportadas pk_operacionesnoreportadas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.operacionesnoreportadas
    ADD CONSTRAINT pk_operacionesnoreportadas PRIMARY KEY (id_load_local, idoperacion);
--
-- PostgreSQL database dump complete
--
\unrestrict i0D6TcbkKHrW2D8f4u22Ws1vzVhYMwMOr8dQeO6AqghfZeSCYbYgpI2besrk5hj
