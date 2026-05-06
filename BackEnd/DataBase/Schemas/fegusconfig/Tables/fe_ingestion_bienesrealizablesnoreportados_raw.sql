-- Table: fegusconfig.fe_ingestion_bienesrealizablesnoreportados_raw

-- DROP TABLE IF EXISTS fegusconfig.fe_ingestion_bienesrealizablesnoreportados_raw;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_ingestion_bienesrealizablesnoreportados_raw
(
    id_cliente integer NOT NULL,
    id_load bigint NOT NULL,
    session_id uuid NOT NULL,
    id_raw bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    seq bigint NOT NULL,
    payload jsonb NOT NULL,
    received_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT fe_ingestion_bienesrealizablesnoreportados_raw_pkey PRIMARY KEY (id_cliente, id_load, session_id, id_raw),
    CONSTRAINT fk_ingestion_bienesrealizablesnoreportados_session FOREIGN KEY (id_cliente, id_load, session_id)
        REFERENCES fegusconfig.fe_ingestion_sessions (id_cliente, id_load, session_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_ingestion_bienesrealizablesnoreportados_raw
    OWNER to postgres;
-- Index: idx_fe_ingestion_bienesrealizablesnoreportados_raw_session

-- DROP INDEX IF EXISTS fegusconfig.idx_fe_ingestion_bienesrealizablesnoreportados_raw_session;

CREATE INDEX IF NOT EXISTS idx_fe_ingestion_bienesrealizablesnoreportados_raw_session
    ON fegusconfig.fe_ingestion_bienesrealizablesnoreportados_raw USING btree
    (session_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: ux_fe_ingestion_bienesrealizablesnoreportados_raw_session_seq

-- DROP INDEX IF EXISTS fegusconfig.ux_fe_ingestion_bienesrealizablesnoreportados_raw_session_seq;

CREATE UNIQUE INDEX IF NOT EXISTS ux_fe_ingestion_bienesrealizablesnoreportados_raw_session_seq
    ON fegusconfig.fe_ingestion_bienesrealizablesnoreportados_raw USING btree
    (session_id ASC NULLS LAST, seq ASC NULLS LAST)
    TABLESPACE pg_default;
