-- Table: fegusconfig.fe_box_state_events

-- DROP TABLE IF EXISTS fegusconfig.fe_box_state_events;

CREATE TABLE IF NOT EXISTS fegusconfig.fe_box_state_events
(
    id_cliente integer NOT NULL,
    id_load bigint NOT NULL,
    id_event bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    state_code character varying(30) COLLATE pg_catalog."default" NOT NULL,
    message text COLLATE pg_catalog."default",
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT pk_fe_box_state_events PRIMARY KEY (id_cliente, id_load, id_event),
    CONSTRAINT fk_box_state_events_box FOREIGN KEY (id_cliente, id_load)
        REFERENCES fegusconfig.fe_box_data_load (id_cliente, id_load) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT fk_box_state_events_state FOREIGN KEY (state_code)
        REFERENCES fegusconfig.fe_box_state (state_code) MATCH SIMPLE
        ON UPDATE CASCADE
        ON DELETE RESTRICT
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusconfig.fe_box_state_events
    OWNER to postgres;

COMMENT ON TABLE fegusconfig.fe_box_state_events
    IS 'Tabla de auditoria que registra cada evento de cambio de estado de un Box dentro de la maquina de estados del motor FEGUS';

COMMENT ON COLUMN fegusconfig.fe_box_state_events.id_cliente
    IS 'Identificador de la entidad financiera propietaria del Box';

COMMENT ON COLUMN fegusconfig.fe_box_state_events.id_load
    IS 'Identificador unico del Box sobre el cual se genera el evento de estado';

COMMENT ON COLUMN fegusconfig.fe_box_state_events.id_event
    IS 'Consecutivo unico del evento de estado dentro del Box (identity)';

COMMENT ON COLUMN fegusconfig.fe_box_state_events.state_code
    IS 'Codigo del estado al cual transiciona el Box, definido en fegusconfig.fe_box_state';

COMMENT ON COLUMN fegusconfig.fe_box_state_events.message
    IS 'Mensaje descriptivo asociado al evento de cambio de estado, puede incluir informacion tecnica o contextual';

COMMENT ON COLUMN fegusconfig.fe_box_state_events.created_at_utc
    IS 'Fecha y hora en formato UTC en que se registra el evento de cambio de estado';