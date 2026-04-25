-- Table: feguslocal.fideicomiso

-- DROP TABLE IF EXISTS feguslocal.fideicomiso;

CREATE TABLE IF NOT EXISTS feguslocal.fideicomiso
(
    id_load_local bigint NOT NULL,
    idfideicomisogarantia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date NOT NULL,
    valornominalfideicomiso numeric(18,2) NOT NULL,
    tipomonedavalornominalfideicomiso character varying(5) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_fideicomiso PRIMARY KEY (id_load_local, idfideicomisogarantia)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.fideicomiso
    OWNER to postgres;