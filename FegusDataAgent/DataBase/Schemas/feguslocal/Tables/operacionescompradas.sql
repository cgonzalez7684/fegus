-- Table: feguslocal.operacionescompradas

-- DROP TABLE IF EXISTS feguslocal.operacionescompradas;

CREATE TABLE IF NOT EXISTS feguslocal.operacionescompradas
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonaentidadoperacion character varying(2) COLLATE pg_catalog."default" NOT NULL,
    identidadoperacioncomprada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudorcomprada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncreditocomprada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fechadesembolsodeudor date NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_operacionescompradas PRIMARY KEY (id_load_local, idoperacioncredito, tipopersonaentidadoperacion, identidadoperacioncomprada, tipopersonadeudor, iddeudorcomprada, idoperacioncreditocomprada)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.operacionescompradas
    OWNER to postgres;