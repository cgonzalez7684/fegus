--
-- PostgreSQL database dump
--
\restrict f1RRcsb4qTXwyJk1qWokRB59ZNjWfLfe5Oh1ErQ5jYOfkEfjb3NG6lTNBbN29MF
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
-- Name: modificacion; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.modificacion (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    fechamodificacion date NOT NULL,
    tipomodificacion character varying(10) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.modificacion OWNER TO postgres;
--
-- Name: modificacion pk_modificacion; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.modificacion
    ADD CONSTRAINT pk_modificacion PRIMARY KEY (id_load_local, idoperacioncredito, tipomodificacion);
--
-- PostgreSQL database dump complete
--
\unrestrict f1RRcsb4qTXwyJk1qWokRB59ZNjWfLfe5Oh1ErQ5jYOfkEfjb3NG6lTNBbN29MF
