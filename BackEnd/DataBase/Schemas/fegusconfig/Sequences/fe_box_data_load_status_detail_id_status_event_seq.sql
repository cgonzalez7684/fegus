-- SEQUENCE: fegusconfig.fe_box_data_load_status_detail_id_status_event_seq

-- DROP SEQUENCE IF EXISTS fegusconfig.fe_box_data_load_status_detail_id_status_event_seq;

CREATE SEQUENCE IF NOT EXISTS fegusconfig.fe_box_data_load_status_detail_id_status_event_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE fegusconfig.fe_box_data_load_status_detail_id_status_event_seq
    OWNER TO postgres;