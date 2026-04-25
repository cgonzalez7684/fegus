-- Table: fegusconfig.fe_box_state_transition

-- DROP TABLE IF EXISTS fegusconfig.fe_box_state_transition;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_box_state_transition
(
    from_state character varying(30) COLLATE pg_catalog."default" NOT NULL,
    to_state character varying(30) COLLATE pg_catalog."default" NOT NULL,
    transition_name character varying(50) COLLATE pg_catalog."default",
    is_active character varying(1) COLLATE pg_catalog."default" NOT NULL DEFAULT 'A'::character varying,
    CONSTRAINT pk_box_state_transition PRIMARY KEY (from_state, to_state),
    CONSTRAINT fk_transition_from FOREIGN KEY (from_state)
        REFERENCES fegusconfig.fe_box_state (state_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_transition_to FOREIGN KEY (to_state)
        REFERENCES fegusconfig.fe_box_state (state_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_box_state_transition
    OWNER to postgres;