--
-- PostgreSQL database dump
--
\restrict jjfY2VIxe10KBLDYhpJdeVUepIuz4Vkjz4IhiOrGyJFedLAq3pZhigWDRgVHfSK
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
-- Name: fe_box_data_load; Type: TABLE; Schema: feguslocal; Owner: postgres
--
CREATE TABLE feguslocal.fe_box_data_load (
    id_cliente integer NOT NULL,
    id_load bigint,
    id_load_local bigint NOT NULL,
    state_code character varying(30),
    is_active character varying(1),
    asofdate timestamp without time zone,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
ALTER TABLE feguslocal.fe_box_data_load OWNER TO postgres;
--
-- Name: COLUMN fe_box_data_load.id_cliente; Type: COMMENT; Schema: feguslocal; Owner: postgres
--
COMMENT ON COLUMN feguslocal.fe_box_data_load.id_cliente IS 'Identificacion de la entidad financiera';
--
-- Name: COLUMN fe_box_data_load.id_load; Type: COMMENT; Schema: feguslocal; Owner: postgres
--
COMMENT ON COLUMN feguslocal.fe_box_data_load.id_load IS 'Consecutivo numerico que identifica la caja (box) de datos cargados';
--
-- Name: COLUMN fe_box_data_load.id_load_local; Type: COMMENT; Schema: feguslocal; Owner: postgres
--
COMMENT ON COLUMN feguslocal.fe_box_data_load.id_load_local IS 'Consecutivo numerico dado por la entidad financiera';
--
-- Name: COLUMN fe_box_data_load.state_code; Type: COMMENT; Schema: feguslocal; Owner: postgres
--
COMMENT ON COLUMN feguslocal.fe_box_data_load.state_code IS 'Este representa el estado en el que se encuentra el proceso de gestion sobre los datos cargados de este id_load';
--
-- Name: COLUMN fe_box_data_load.is_active; Type: COMMENT; Schema: feguslocal; Owner: postgres
--
COMMENT ON COLUMN feguslocal.fe_box_data_load.is_active IS 'Este representa el estado activo (A) o inactivo (I) del id_load';
--
-- Name: fe_box_data_load_id_load_local_seq; Type: SEQUENCE; Schema: feguslocal; Owner: postgres
--
ALTER TABLE feguslocal.fe_box_data_load ALTER COLUMN id_load_local ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME feguslocal.fe_box_data_load_id_load_local_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
--
-- Name: fe_box_data_load fe_box_data_load_id_load_key; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.fe_box_data_load
    ADD CONSTRAINT fe_box_data_load_id_load_key UNIQUE (id_load);
--
-- Name: fe_box_data_load pk_fe_box_data_load; Type: CONSTRAINT; Schema: feguslocal; Owner: postgres
--
ALTER TABLE ONLY feguslocal.fe_box_data_load
    ADD CONSTRAINT pk_fe_box_data_load PRIMARY KEY (id_cliente, id_load_local);
--
-- Name: idx_fe_box_data_load_1; Type: INDEX; Schema: feguslocal; Owner: postgres
--
CREATE INDEX idx_fe_box_data_load_1 ON feguslocal.fe_box_data_load USING btree (id_cliente);
--
-- Name: idx_fe_box_data_load_2; Type: INDEX; Schema: feguslocal; Owner: postgres
--
CREATE INDEX idx_fe_box_data_load_2 ON feguslocal.fe_box_data_load USING btree (id_cliente, id_load);
--
-- Name: idx_fe_box_data_load_3; Type: INDEX; Schema: feguslocal; Owner: postgres
--
CREATE INDEX idx_fe_box_data_load_3 ON feguslocal.fe_box_data_load USING btree (id_cliente, is_active);
--
-- Name: idx_fe_box_data_load_4; Type: INDEX; Schema: feguslocal; Owner: postgres
--
CREATE INDEX idx_fe_box_data_load_4 ON feguslocal.fe_box_data_load USING btree (created_at_utc);
--
-- Name: idx_fe_box_data_load_5; Type: INDEX; Schema: feguslocal; Owner: postgres
--
CREATE INDEX idx_fe_box_data_load_5 ON feguslocal.fe_box_data_load USING btree (updated_at_utc);
--
-- PostgreSQL database dump complete
--
\unrestrict jjfY2VIxe10KBLDYhpJdeVUepIuz4Vkjz4IhiOrGyJFedLAq3pZhigWDRgVHfSK
