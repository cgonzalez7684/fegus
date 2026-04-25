-- Table: fegusconfig.fe_box_state

-- DROP TABLE IF EXISTS fegusconfig.fe_box_state;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_box_state
(
    state_code character varying(30) COLLATE pg_catalog."default" NOT NULL,
    state_name character varying(50) COLLATE pg_catalog."default" NOT NULL,
    is_initial boolean NOT NULL DEFAULT false,
    is_final boolean NOT NULL DEFAULT false,
    is_error_state boolean NOT NULL DEFAULT false,
    is_active character varying(1) COLLATE pg_catalog."default" NOT NULL DEFAULT 'A'::character varying,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT fe_box_state_pkey PRIMARY KEY (state_code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_box_state
    OWNER to postgres;