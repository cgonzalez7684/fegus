-- Table: feguslocal.ingresodeudores

-- DROP TABLE IF EXISTS feguslocal.ingresodeudores;

CREATE TABLE IF NOT EXISTS feguslocal.ingresodeudores
(
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipoingresodeudor character varying(10) COLLATE pg_catalog."default" NOT NULL,
    montoingresodeudor numeric(18,2) NOT NULL,
    tipomonedaingreso character varying(5) COLLATE pg_catalog."default" NOT NULL,
    fechaverificacioningreso date,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_ingresodeudores PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor, tipoingresodeudor, tipomonedaingreso)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.ingresodeudores
    OWNER to postgres;