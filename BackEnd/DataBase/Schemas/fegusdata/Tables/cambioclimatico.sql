-- Table: fegusdata.cambioclimatico

-- DROP TABLE IF EXISTS fegusdata.cambioclimatico;

CREATE TABLE IF NOT EXISTS fegusdata.cambioclimatico
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
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
    CONSTRAINT pk_cambioclimatico PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.cambioclimatico
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_cambioclimatico_idx1
ON fegusdata.cambioclimatico (
    id_cliente,
    id_load,
    idoperacioncredito    
);     