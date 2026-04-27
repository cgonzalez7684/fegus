--
-- PostgreSQL database dump
--
\restrict 5s4i1LW0bFL1Gd3sLhgBOpqqOcJFZWRw8JkemB48S9zgLngxHOZpwW56PEQxksj
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
--
-- Name: seq_deudor; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--
CREATE SEQUENCE feguslocal.seq_deudor
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE feguslocal.seq_deudor OWNER TO postgres;
--
-- PostgreSQL database dump complete
--
\unrestrict 5s4i1LW0bFL1Gd3sLhgBOpqqOcJFZWRw8JkemB48S9zgLngxHOZpwW56PEQxksj
