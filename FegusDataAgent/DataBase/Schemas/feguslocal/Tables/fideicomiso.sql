CREATE TABLE feguslocal.fideicomiso (
    id_load_local bigint NOT NULL,
    idfideicomisogarantia character varying(50) NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date NOT NULL,
    valornominalfideicomiso numeric(18,2) NOT NULL,
    tipomonedavalornominalfideicomiso character varying(5) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
