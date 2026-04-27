CREATE TABLE feguslocal.ingresodeudores (
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    tipoingresodeudor character varying(10) NOT NULL,
    montoingresodeudor numeric(18,2) NOT NULL,
    tipomonedaingreso character varying(5) NOT NULL,
    fechaverificacioningreso date,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
