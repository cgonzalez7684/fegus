-- Table: fegusconfig.fe_status_result

-- DROP TABLE IF EXISTS fegusconfig.fe_status_result;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_status_result
(
    status_result character varying(15) COLLATE pg_catalog."default" NOT NULL,
    result_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    result_description character varying(200) COLLATE pg_catalog."default",
    is_final_state boolean NOT NULL DEFAULT false,
    is_success boolean NOT NULL DEFAULT false,
    is_active character varying(1) COLLATE pg_catalog."default" NOT NULL DEFAULT 'A'::character varying,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_fe_status_result PRIMARY KEY (status_result)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_status_result
    OWNER to postgres;