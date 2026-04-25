-- Table: fegusconfig.fe_workflow_step

-- DROP TABLE IF EXISTS fegusconfig.fe_workflow_step;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_workflow_step
(
    step_code character varying(40) COLLATE pg_catalog."default" NOT NULL,
    step_name character varying(80) COLLATE pg_catalog."default" NOT NULL,
    execution_order integer NOT NULL,
    parent_state character varying(30) COLLATE pg_catalog."default" NOT NULL,
    is_active character varying(1) COLLATE pg_catalog."default" NOT NULL DEFAULT 'A'::character varying,
    CONSTRAINT fe_workflow_step_pkey PRIMARY KEY (step_code),
    CONSTRAINT fk_box_status FOREIGN KEY (parent_state)
        REFERENCES fegusconfig.fe_box_state (state_code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_workflow_step
    OWNER to postgres;