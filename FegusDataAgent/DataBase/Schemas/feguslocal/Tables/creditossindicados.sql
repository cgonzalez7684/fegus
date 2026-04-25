-- Table: feguslocal.creditossindicados

-- DROP TABLE IF EXISTS feguslocal.creditossindicados;

CREATE TABLE IF NOT EXISTS feguslocal.creditossindicados
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersona character varying(2) COLLATE pg_catalog."default" NOT NULL,
    identidadcreditosindicado character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncreditoentidadcreditosindicado character varying(50) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_creditossindicados PRIMARY KEY (id_load_local, idoperacioncredito, tipopersona, identidadcreditosindicado, idoperacioncreditoentidadcreditosindicado)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.creditossindicados
    OWNER to postgres;