-- Table: feguslocal.fe_box_data_load

-- DROP TABLE IF EXISTS feguslocal.fe_box_data_load;

CREATE TABLE IF NOT EXISTS feguslocal.fe_box_data_load
(
    id_cliente integer NOT NULL,
    id_load bigint,
    id_load_local bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    state_code character varying(30) COLLATE pg_catalog."default",
    is_active character varying(1) COLLATE pg_catalog."default",
    asofdate timestamp without time zone,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_fe_box_data_load PRIMARY KEY (id_cliente, id_load_local),
    CONSTRAINT fe_box_data_load_id_load_key UNIQUE (id_load)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.fe_box_data_load
    OWNER to postgres;

COMMENT ON COLUMN feguslocal.fe_box_data_load.id_cliente
    IS 'Identificacion de la entidad financiera';

COMMENT ON COLUMN feguslocal.fe_box_data_load.id_load
    IS 'Consecutivo numerico que identifica la caja (box) de datos cargados';

COMMENT ON COLUMN feguslocal.fe_box_data_load.id_load_local
    IS 'Consecutivo numerico dado por la entidad financiera';

COMMENT ON COLUMN feguslocal.fe_box_data_load.state_code
    IS 'Este representa el estado en el que se encuentra el proceso de gestion sobre los datos cargados de este id_load';

COMMENT ON COLUMN feguslocal.fe_box_data_load.is_active
    IS 'Este representa el estado activo (A) o inactivo (I) del id_load';
-- Index: idx_fe_box_data_load_1

-- DROP INDEX IF EXISTS feguslocal.idx_fe_box_data_load_1;

CREATE INDEX IF NOT EXISTS idx_fe_box_data_load_1
    ON feguslocal.fe_box_data_load USING btree
    (id_cliente ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_fe_box_data_load_2

-- DROP INDEX IF EXISTS feguslocal.idx_fe_box_data_load_2;

CREATE INDEX IF NOT EXISTS idx_fe_box_data_load_2
    ON feguslocal.fe_box_data_load USING btree
    (id_cliente ASC NULLS LAST, id_load ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_fe_box_data_load_3

-- DROP INDEX IF EXISTS feguslocal.idx_fe_box_data_load_3;

CREATE INDEX IF NOT EXISTS idx_fe_box_data_load_3
    ON feguslocal.fe_box_data_load USING btree
    (id_cliente ASC NULLS LAST, is_active COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_fe_box_data_load_4

-- DROP INDEX IF EXISTS feguslocal.idx_fe_box_data_load_4;

CREATE INDEX IF NOT EXISTS idx_fe_box_data_load_4
    ON feguslocal.fe_box_data_load USING btree
    (created_at_utc ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_fe_box_data_load_5

-- DROP INDEX IF EXISTS feguslocal.idx_fe_box_data_load_5;

CREATE INDEX IF NOT EXISTS idx_fe_box_data_load_5
    ON feguslocal.fe_box_data_load USING btree
    (updated_at_utc ASC NULLS LAST)
    TABLESPACE pg_default;