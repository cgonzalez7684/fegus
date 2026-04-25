-- Table: fegusconfig.fe_box_workflow_execution

-- DROP TABLE IF EXISTS fegusconfig.fe_box_workflow_execution;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_box_workflow_execution
(
    id_cliente integer NOT NULL,
    id_load bigint NOT NULL,
    step_code character varying(40) COLLATE pg_catalog."default" NOT NULL,
    status_result character varying(15) COLLATE pg_catalog."default" NOT NULL,
    started_at_utc timestamp without time zone,
    finished_at_utc timestamp without time zone,
    duration_ms bigint,
    error_message text COLLATE pg_catalog."default",
    CONSTRAINT pk_box_workflow_execution PRIMARY KEY (id_cliente, id_load, step_code),
    CONSTRAINT fk_status_execution FOREIGN KEY (status_result)
        REFERENCES fegusconfig.fe_status_result (status_result) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT fk_step_execution FOREIGN KEY (step_code)
        REFERENCES fegusconfig.fe_workflow_step (step_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT,
    CONSTRAINT fk_workflow_box FOREIGN KEY (id_cliente, id_load)
        REFERENCES fegusconfig.fe_box_data_load (id_cliente, id_load) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_box_workflow_execution
    OWNER to postgres;