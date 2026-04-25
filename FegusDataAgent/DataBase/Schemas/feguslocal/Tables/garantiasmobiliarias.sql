-- Table: feguslocal.garantiasmobiliarias

-- DROP TABLE IF EXISTS feguslocal.garantiasmobiliarias;

CREATE TABLE IF NOT EXISTS feguslocal.garantiasmobiliarias
(
    id_load_local bigint NOT NULL,
    idgarantiamobiliaria character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fechapublicidadgm date NOT NULL,
    montogarantiamobiliaria numeric(18,2) NOT NULL,
    fechavencimientogm date NOT NULL,
    fechamontoreferencia date NOT NULL,
    montoreferencia numeric(18,2) NOT NULL,
    tipomonedamontoreferencia character varying(5) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_garantiasmobiliarias PRIMARY KEY (id_load_local, idgarantiamobiliaria)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.garantiasmobiliarias
    OWNER to postgres;