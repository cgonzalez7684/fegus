--
-- PostgreSQL database dump
--
\restrict 2Jrh0y1MVFMgetfQivJQrDBEqcs8MmKwl4zGZi91aJetX0beFFZPF56NwUev5tY
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
-- Name: cuentasxcobrar; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.cuentasxcobrar (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    idcuentacobrarasociada character varying(50) NOT NULL,
    cuentacontablecuentacobrarasociada character varying(50) NOT NULL,
    tipocatalogosugef character varying(10) NOT NULL,
    saldocuentacobrarasociada numeric(18,2) NOT NULL,
    tipomonedacuentacobrarasociada character varying(5) NOT NULL,
    diasatrasocuentacobrarasociada integer NOT NULL,
    fecharegistrocuentacobrarasociada date NOT NULL,
    fechavencimientocuentacobrarasociada date NOT NULL,
    concepto character varying(255),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.cuentasxcobrar OWNER TO postgres;
--
-- Name: cuentasxcobrar pk_cuentasxcobrar; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.cuentasxcobrar
    ADD CONSTRAINT pk_cuentasxcobrar PRIMARY KEY (id_load_local, idoperacioncredito, idcuentacobrarasociada);
--
-- PostgreSQL database dump complete
--
\unrestrict 2Jrh0y1MVFMgetfQivJQrDBEqcs8MmKwl4zGZi91aJetX0beFFZPF56NwUev5tY
