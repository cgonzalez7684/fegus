-- Table: fegusconfig.fe_box_data_load_status_detail

-- DROP TABLE IF EXISTS fegusconfig.fe_box_data_load_status_detail;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_box_data_load_status_detail
(
    id_cliente integer NOT NULL,
    id_load bigint NOT NULL,
    id_status_event bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    state_code character varying(30) COLLATE pg_catalog."default" NOT NULL,
    status_result character varying(10) COLLATE pg_catalog."default" NOT NULL,
    message text COLLATE pg_catalog."default",
    started_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    finished_at_utc timestamp without time zone,
    duration_ms bigint,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT pk_box_status_detail PRIMARY KEY (id_cliente, id_load, id_status_event),
    CONSTRAINT fk_box_detail_header FOREIGN KEY (id_cliente, id_load)
        REFERENCES fegusconfig.fe_box_data_load (id_cliente, id_load) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT fk_box_status_detail FOREIGN KEY (status_result)
        REFERENCES fegusconfig.fe_status_result (status_result) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT fk_state_box FOREIGN KEY (state_code)
        REFERENCES fegusconfig.fe_box_state (state_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_box_data_load_status_detail
    OWNER to postgres;