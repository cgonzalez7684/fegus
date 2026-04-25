-- Table: feguslocal.bienesrealizablesnoreportados

-- DROP TABLE IF EXISTS feguslocal.bienesrealizablesnoreportados;

CREATE TABLE IF NOT EXISTS feguslocal.bienesrealizablesnoreportados
(
    id_load_local bigint NOT NULL,
    idbienrealizable character varying(50) COLLATE pg_catalog."default" NOT NULL,
    indicadorgarantia character varying(1) COLLATE pg_catalog."default" NOT NULL,
    idgarantia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idbien character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipobien character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipomotivobienrealizablenoreportado character varying(10) COLLATE pg_catalog."default" NOT NULL,
    ultimovalorcontable numeric(18,2) NOT NULL,
    valorrecuperadoneto numeric(18,2) NOT NULL,
    idoperacioncreditofinanciamiento character varying(50) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_bienesrealizablesnoreportados PRIMARY KEY (id_load_local, idbienrealizable)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.bienesrealizablesnoreportados
    OWNER to postgres;