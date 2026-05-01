CREATE TABLE feguslocal.garantiaspolizas (
    id_load_local bigint NOT NULL,
    idgarantia character varying(25) NOT NULL,
    tipogarantia numeric(5,0) NOT NULL,
    tipobiengarantia numeric(5,0) NOT NULL,
    tipopoliza numeric(2,0) NOT NULL,
    montopoliza numeric(20,2) NOT NULL,
    fechavencimientopoliza date NOT NULL,
    indicadorcoberturaspoliza character varying(1) NOT NULL,
    tipopersonabeneficiario numeric(2,0) NOT NULL,
    idbeneficiario character varying(30) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
