-- Table: feguslocal.gravamenes

-- DROP TABLE IF EXISTS feguslocal.gravamenes;

CREATE TABLE IF NOT EXISTS feguslocal.gravamenes
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idgarantia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipomitigador character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipodocumentolegal character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipogradogravamenes character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipopersonaacreedor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    idacreedor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    montogradogravamen numeric(18,2) NOT NULL,
    tipomonedamonto character varying(5) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_gravamenes PRIMARY KEY (id_load_local, idoperacioncredito, idgarantia, tipomitigador, tipodocumentolegal, tipogradogravamenes, tipopersonaacreedor, idacreedor)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.gravamenes
    OWNER to postgres;