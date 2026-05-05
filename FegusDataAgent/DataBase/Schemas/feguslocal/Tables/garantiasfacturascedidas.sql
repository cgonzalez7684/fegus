CREATE TABLE feguslocal.garantiasfacturascedidas (
    id_load_local bigint NOT NULL,
    idgarantiafacturacedida character varying(25) NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date,
    tipopersona numeric(2,0) NOT NULL,
    idobligado character varying(30) NOT NULL,
    valornominalgarantia numeric(20,2) NOT NULL,
    tipomonedavalornominal numeric(6,0) NOT NULL,
    porcentajeajusterc numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
