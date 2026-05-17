-- Table: fegusdata.operacionesnoreportadas

-- DROP TABLE IF EXISTS fegusdata.operacionesnoreportadas;

CREATE TABLE IF NOT EXISTS fegusdata.operacionesnoreportadas
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    tipopersona character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacion character varying(50) COLLATE pg_catalog."default" NOT NULL,
    motivoliquidacion character varying(10) COLLATE pg_catalog."default" NOT NULL,
    fechaliquidacion date NOT NULL,
    saldoprincipalliquidado numeric(18,2) NOT NULL,
    saldoproductosliquidado numeric(18,2) NOT NULL,
    idoperacionnueva character varying(50) COLLATE pg_catalog."default",
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_operacionesnoreportadas PRIMARY KEY (id_cliente, id_load, session_id, idoperacion)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.operacionesnoreportadas
    OWNER to postgres;


CREATE INDEX IF NOT EXISTS ix_operacionesnoreportadas_idx1
ON fegusdata.operacionesnoreportadas (
    id_cliente,
    id_load,
    idoperacion       
);      