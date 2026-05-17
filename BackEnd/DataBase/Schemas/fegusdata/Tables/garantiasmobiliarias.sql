-- Table: fegusdata.garantiasmobiliarias

-- DROP TABLE IF EXISTS fegusdata.garantiasmobiliarias;

CREATE TABLE IF NOT EXISTS fegusdata.garantiasmobiliarias
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idgarantiamobiliaria character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fechapublicidadgm date NOT NULL,
    montogarantiamobiliaria numeric(18,2) NOT NULL,
    fechavencimientogm date NOT NULL,
    fechamontoreferencia date NOT NULL,
    montoreferencia numeric(18,2) NOT NULL,
    tipomonedamontoreferencia character varying(5) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_garantiasmobiliarias PRIMARY KEY (id_cliente, id_load, session_id, idgarantiamobiliaria)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.garantiasmobiliarias
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_garantiasmobiliarias_idx1
ON fegusdata.garantiasmobiliarias (
    id_cliente,
    id_load,
    idgarantiamobiliaria       
);     