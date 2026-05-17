-- Table: fegusdata.codeudores

-- DROP TABLE IF EXISTS fegusdata.codeudores;

CREATE TABLE IF NOT EXISTS fegusdata.codeudores
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonacodeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    idcodeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_codeudores PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, idcodeudor, tipopersonacodeudor)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.codeudores
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_codeudores_idx1
ON fegusdata.codeudores (
    id_cliente,
    id_load,
    idoperacioncredito ,
    idcodeudor   
);     