-- Table: feguslocal.cambioclimatico

-- DROP TABLE IF EXISTS feguslocal.cambioclimatico;

CREATE TABLE IF NOT EXISTS feguslocal.cambioclimatico
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipotema character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tiposubtema character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipoactividad character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipoambito character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipofuentefinanciamiento character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipofondofinanciamiento character varying(10) COLLATE pg_catalog."default" NOT NULL,
    saldomontoclimatico numeric(18,2) NOT NULL,
    codigomodalidad character varying(10) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_cambioclimatico PRIMARY KEY (id_load_local, idoperacioncredito)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.cambioclimatico
    OWNER to postgres;