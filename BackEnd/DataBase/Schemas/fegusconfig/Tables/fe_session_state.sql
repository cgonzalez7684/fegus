-- Table: fegusconfig.fe_session_state

-- DROP TABLE IF EXISTS fegusconfig.fe_session_state;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_session_state
(
    session_state_code character varying(30) COLLATE pg_catalog."default" NOT NULL,
    state_name character varying(50) COLLATE pg_catalog."default",
    is_initial boolean DEFAULT false,
    is_final boolean DEFAULT false,
    is_error_state boolean DEFAULT false,
    is_active character varying(1) COLLATE pg_catalog."default" DEFAULT 'A'::character varying,
    CONSTRAINT fe_session_state_pkey PRIMARY KEY (session_state_code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_session_state
    OWNER to postgres;