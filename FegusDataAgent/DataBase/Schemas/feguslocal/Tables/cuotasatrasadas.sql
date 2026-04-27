--
-- PostgreSQL database dump
--
\restrict CL1uq1rylIgdKCFOTUe4dXZpeDsM2CCO98DCpKLNeniOTAOroaXvOBxeGSj4OzF
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
-- Name: cuotasatrasadas; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.cuotasatrasadas (
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipocuota character varying(10) NOT NULL,
    numerocuotaatrasada integer NOT NULL,
    diasatraso integer NOT NULL,
    montocuotaatrasada numeric(18,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.cuotasatrasadas OWNER TO postgres;
--
-- Name: cuotasatrasadas pk_cuotasatrasadas; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.cuotasatrasadas
    ADD CONSTRAINT pk_cuotasatrasadas PRIMARY KEY (id_load_local, idoperacioncredito, tipocuota, numerocuotaatrasada);
--
-- PostgreSQL database dump complete
--
\unrestrict CL1uq1rylIgdKCFOTUe4dXZpeDsM2CCO98DCpKLNeniOTAOroaXvOBxeGSj4OzF
