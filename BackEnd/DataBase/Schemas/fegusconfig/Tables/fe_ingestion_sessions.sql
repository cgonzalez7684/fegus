-- Table: fegusconfig.fe_ingestion_sessions

-- DROP TABLE IF EXISTS fegusconfig.fe_ingestion_sessions;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_ingestion_sessions
(
    id_cliente integer NOT NULL,
    id_load bigint NOT NULL,
    session_id uuid NOT NULL,
    dataset character varying(50) COLLATE pg_catalog."default" NOT NULL,
    session_state_code character varying(30) COLLATE pg_catalog."default" NOT NULL,
    last_sequence bigint NOT NULL DEFAULT 0,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    error_message text COLLATE pg_catalog."default",
    CONSTRAINT pk_fe_ingestion_sessions PRIMARY KEY (id_cliente, id_load, session_id),
    CONSTRAINT fk_box_detail_header FOREIGN KEY (id_cliente, id_load)
        REFERENCES fegusconfig.fe_box_data_load (id_cliente, id_load) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_state_session FOREIGN KEY (session_state_code)
        REFERENCES fegusconfig.fe_session_state (session_state_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_ingestion_sessions
    OWNER to postgres;

COMMENT ON TABLE fegusconfig.fe_ingestion_sessions
    IS 'Tabla que registra las sesiones de ingestion de datos enviadas por el DataAgent o API, incluyendo su estado, control de secuencia y manejo de errores en un modelo multi-tenant';

COMMENT ON COLUMN fegusconfig.fe_ingestion_sessions.id_load
    IS 'Consecutivo numerico que identifica la caja (box) de datos cargados';

COMMENT ON COLUMN fegusconfig.fe_ingestion_sessions.session_id
    IS 'Identificador unico (UUID) que representa la sesion de ingestion de datos iniciada desde el API o DataAgent';

COMMENT ON COLUMN fegusconfig.fe_ingestion_sessions.dataset
    IS 'Nombre logico del dataset regulatorio procesado (ejemplo: Deudores, Operaciones, Garantias)';

COMMENT ON COLUMN fegusconfig.fe_ingestion_sessions.session_state_code
    IS 'Indicata el estado en el que se encuentra la sesion de carga de datos';

COMMENT ON COLUMN fegusconfig.fe_ingestion_sessions.last_sequence
    IS 'Ultimo numero de secuencia procesado dentro del flujo de ingestion para control incremental y reanudacion';

COMMENT ON COLUMN fegusconfig.fe_ingestion_sessions.created_at_utc
    IS 'Fecha y hora en formato UTC en que se creo la sesion de ingestion';

COMMENT ON COLUMN fegusconfig.fe_ingestion_sessions.updated_at_utc
    IS 'Fecha y hora en formato UTC de la ultima actualizacion del estado o metadatos de la sesion';

COMMENT ON COLUMN fegusconfig.fe_ingestion_sessions.error_message
    IS 'Detalle tecnico del error ocurrido durante la sesion de ingestion en caso de fallo del proceso';
-- Index: idx_fe_ingestion_sessions_created_at

-- DROP INDEX IF EXISTS fegusconfig.idx_fe_ingestion_sessions_created_at;

CREATE INDEX IF NOT EXISTS idx_fe_ingestion_sessions_created_at
    ON fegusconfig.fe_ingestion_sessions USING btree
    (created_at_utc ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: idx_fe_ingestion_sessions_dataset_status

-- DROP INDEX IF EXISTS fegusconfig.idx_fe_ingestion_sessions_dataset_status;

CREATE INDEX IF NOT EXISTS idx_fe_ingestion_sessions_dataset_status
    ON fegusconfig.fe_ingestion_sessions USING btree
    (session_id ASC NULLS LAST, dataset COLLATE pg_catalog."default" ASC NULLS LAST, session_state_code COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: ix_fe_ingestion_sessions_state_created

-- DROP INDEX IF EXISTS fegusconfig.ix_fe_ingestion_sessions_state_created;

CREATE INDEX IF NOT EXISTS ix_fe_ingestion_sessions_state_created
    ON fegusconfig.fe_ingestion_sessions USING btree
    (session_state_code COLLATE pg_catalog."default" ASC NULLS LAST, created_at_utc ASC NULLS LAST)
    TABLESPACE pg_default;