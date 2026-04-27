CREATE TABLE feguslocal.fe_box_data_load (
    id_cliente integer NOT NULL,
    id_load bigint,
    id_load_local bigint NOT NULL,
    state_code character varying(30),
    is_active character varying(1),
    asofdate timestamp without time zone,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
