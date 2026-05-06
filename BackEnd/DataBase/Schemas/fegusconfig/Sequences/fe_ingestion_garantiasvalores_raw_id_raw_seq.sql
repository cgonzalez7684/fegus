-- SEQUENCE: fegusconfig.fe_ingestion_garantiasvalores_raw_id_raw_seq

-- DROP SEQUENCE IF EXISTS fegusconfig.fe_ingestion_garantiasvalores_raw_id_raw_seq;

CREATE SEQUENCE IF NOT EXISTS fegusconfig.fe_ingestion_garantiasvalores_raw_id_raw_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE fegusconfig.fe_ingestion_garantiasvalores_raw_id_raw_seq
    OWNER TO postgres;
