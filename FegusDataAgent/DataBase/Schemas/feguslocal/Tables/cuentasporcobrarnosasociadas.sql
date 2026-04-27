--
-- PostgreSQL database dump
--
\restrict FBFixjmJu080TgRWD08xyTxh27ov8Ci5raejhGe9yWMkjleM46NDQrKdQUoDcGl
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
-- Name: cuentasporcobrarnosasociadas; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.cuentasporcobrarnosasociadas (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    idpersona character varying(50) NOT NULL,
    tipomonedamonto character varying(5) NOT NULL,
    montooriginal numeric(18,2) NOT NULL,
    tipocatalogosugef character varying(10) NOT NULL,
    cuentacontablesaldoprincipal character varying(50) NOT NULL,
    saldoprincipal numeric(18,2) NOT NULL,
    cuentacontablesaldoproductosporcobrar character varying(50) NOT NULL,
    saldoproductosporcobrar numeric(18,2) NOT NULL,
    fecharegistrocontable date NOT NULL,
    fechaexigibilidad date NOT NULL,
    fechavencimiento date NOT NULL,
    montoestimacionregistrada numeric(18,2) NOT NULL,
    tipodependencia character varying(10) NOT NULL,
    diasmora integer NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.cuentasporcobrarnosasociadas OWNER TO postgres;
--
-- Name: cuentasporcobrarnosasociadas pk_cuentasporcobrarnosasociadas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.cuentasporcobrarnosasociadas
    ADD CONSTRAINT pk_cuentasporcobrarnosasociadas PRIMARY KEY (id_load_local, idoperacioncredito);
--
-- PostgreSQL database dump complete
--
\unrestrict FBFixjmJu080TgRWD08xyTxh27ov8Ci5raejhGe9yWMkjleM46NDQrKdQUoDcGl
