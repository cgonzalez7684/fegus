-- Table: fegusdata.bienesrealizablesnoreportados

-- DROP TABLE IF EXISTS fegusdata.bienesrealizablesnoreportados;

CREATE TABLE IF NOT EXISTS fegusdata.bienesrealizablesnoreportados
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
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
    CONSTRAINT pk_bienesrealizablesnoreportados PRIMARY KEY (id_cliente, id_load, session_id, idbienrealizable)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.bienesrealizablesnoreportados
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_bienesrealizablesnoreportados_idx1
ON fegusdata.bienesrealizablesnoreportados (
    id_cliente,
    id_load,
    idbienrealizable    
);      