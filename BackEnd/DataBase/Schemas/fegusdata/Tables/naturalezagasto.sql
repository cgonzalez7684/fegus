-- Table: fegusdata.naturalezagasto

-- DROP TABLE IF EXISTS fegusdata.naturalezagasto;

CREATE TABLE IF NOT EXISTS fegusdata.naturalezagasto
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tiponaturalezagasto character varying(10) COLLATE pg_catalog."default" NOT NULL,
    porcentajenaturalezagasto numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_naturalezagasto PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, tiponaturalezagasto)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.naturalezagasto
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_naturalezagasto_idx1
ON fegusdata.naturalezagasto (
    id_cliente,
    id_load,
    idoperacioncredito       
);      

CREATE INDEX IF NOT EXISTS ix_naturalezagasto_idx2
ON fegusdata.naturalezagasto (
    id_cliente,
    id_load,
    idoperacioncredito,
    tiponaturalezagasto       
); 