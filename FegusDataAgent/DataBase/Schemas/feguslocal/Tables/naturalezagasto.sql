-- Table: feguslocal.naturalezagasto

-- DROP TABLE IF EXISTS feguslocal.naturalezagasto;

CREATE TABLE IF NOT EXISTS feguslocal.naturalezagasto
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tiponaturalezagasto character varying(10) COLLATE pg_catalog."default" NOT NULL,
    porcentajenaturalezagasto numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_naturalezagasto PRIMARY KEY (id_load_local, idoperacioncredito, tiponaturalezagasto)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.naturalezagasto
    OWNER to postgres;