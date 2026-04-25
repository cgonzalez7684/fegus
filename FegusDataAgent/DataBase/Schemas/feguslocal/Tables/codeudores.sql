-- Table: feguslocal.codeudores

-- DROP TABLE IF EXISTS feguslocal.codeudores;

CREATE TABLE IF NOT EXISTS feguslocal.codeudores
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonacodeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    idcodeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_codeudores PRIMARY KEY (id_load_local, idoperacioncredito, idcodeudor, tipopersonacodeudor)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.codeudores
    OWNER to postgres;