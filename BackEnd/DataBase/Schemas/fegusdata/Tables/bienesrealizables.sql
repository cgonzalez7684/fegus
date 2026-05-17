-- Table: fegusdata.bienesrealizables

-- DROP TABLE IF EXISTS fegusdata.bienesrealizables;

CREATE TABLE IF NOT EXISTS fegusdata.bienesrealizables
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
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
    CONSTRAINT pk_bienesrealizables PRIMARY KEY (id_cliente, id_load, session_id, idbienrealizable)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.bienesrealizables
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_bienesrealizables_idx1
ON fegusdata.bienesrealizables (
    id_cliente,
    id_load,
    idbienrealizable    
);  