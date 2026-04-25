-- SEQUENCE: feguslocal.fe_box_data_load_id_load_local_seq

-- DROP SEQUENCE IF EXISTS feguslocal.fe_box_data_load_id_load_local_seq;

CREATE SEQUENCE IF NOT EXISTS feguslocal.fe_box_data_load_id_load_local_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE feguslocal.fe_box_data_load_id_load_local_seq
    OWNER TO postgres;