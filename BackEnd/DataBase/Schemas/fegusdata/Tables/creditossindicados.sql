-- Table: fegusdata.creditossindicados

-- DROP TABLE IF EXISTS fegusdata.creditossindicados;

CREATE TABLE IF NOT EXISTS fegusdata.creditossindicados
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersona character varying(2) COLLATE pg_catalog."default" NOT NULL,
    identidadcreditosindicado character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncreditoentidadcreditosindicado character varying(50) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_creditossindicados PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, tipopersona, identidadcreditosindicado, idoperacioncreditoentidadcreditosindicado)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.creditossindicados
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_creditossindicados_idx1
ON fegusdata.creditossindicados (
    id_cliente,
    id_load,
    idoperacioncredito       
);     