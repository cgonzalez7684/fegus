-- Table: fegusdata.operacionescompradas

-- DROP TABLE IF EXISTS fegusdata.operacionescompradas;

CREATE TABLE IF NOT EXISTS fegusdata.operacionescompradas
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonaentidadoperacion character varying(2) COLLATE pg_catalog."default" NOT NULL,
    identidadoperacioncomprada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudorcomprada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncreditocomprada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fechadesembolsodeudor date NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_operacionescompradas PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, tipopersonaentidadoperacion, identidadoperacioncomprada, tipopersonadeudor, iddeudorcomprada, idoperacioncreditocomprada)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.operacionescompradas
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_operacionescompradas_idx1
ON fegusdata.operacionescompradas (
    id_cliente,
    id_load,
    idoperacioncredito       
); 

CREATE INDEX IF NOT EXISTS ix_operacionescompradas_idx2
ON fegusdata.operacionescompradas (
    id_cliente,
    id_load,
    idoperacioncredito,
    idoperacioncreditocomprada       
);    