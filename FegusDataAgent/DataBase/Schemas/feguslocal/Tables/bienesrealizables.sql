-- Table: feguslocal.bienesrealizables

-- DROP TABLE IF EXISTS feguslocal.bienesrealizables;

CREATE TABLE IF NOT EXISTS feguslocal.bienesrealizables
(
    id_load_local bigint NOT NULL,
    tipoadquisicionbien character varying(10) COLLATE pg_catalog."default" NOT NULL,
    idbienrealizable character varying(50) COLLATE pg_catalog."default" NOT NULL,
    indicadorgarantia character varying(1) COLLATE pg_catalog."default" NOT NULL,
    idgarantia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idbien character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipobien character varying(10) COLLATE pg_catalog."default" NOT NULL,
    fechaadjudicaciondacionbien date NOT NULL,
    saldoregistrocontable numeric(18,2) NOT NULL,
    tipomonedasaldoregistrocontable character varying(5) COLLATE pg_catalog."default" NOT NULL,
    cuentacatalogosugef character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipocatalogosugef character varying(10) COLLATE pg_catalog."default" NOT NULL,
    fechaultimatasacionbien date NOT NULL,
    montoultimatasacion numeric(18,2) NOT NULL,
    tipomonedamontoavaluo character varying(5) COLLATE pg_catalog."default" NOT NULL,
    tipopersonatasador character varying(2) COLLATE pg_catalog."default" NOT NULL,
    idtasador character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonaempresatasadora character varying(2) COLLATE pg_catalog."default" NOT NULL,
    idempresatasadora character varying(50) COLLATE pg_catalog."default" NOT NULL,
    saldocontablecreditocancelado numeric(18,2) NOT NULL,
    tipomonedasaldocontablecreditocancelado character varying(5) COLLATE pg_catalog."default" NOT NULL,
    montoestimacion numeric(18,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_bienesrealizables PRIMARY KEY (id_load_local, idbienrealizable)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.bienesrealizables
    OWNER to postgres;