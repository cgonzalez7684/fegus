-- Table: fegusdata.garantiaspolizas

-- DROP TABLE IF EXISTS fegusdata.garantiaspolizas;

CREATE TABLE IF NOT EXISTS fegusdata.garantiaspolizas
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idgarantia character varying(25) COLLATE pg_catalog."default" NOT NULL,
    tipogarantia numeric(5,0) NOT NULL,
    tipobiengarantia numeric(5,0) NOT NULL,
    tipopoliza numeric(2,0) NOT NULL,
    montopoliza numeric(20,2) NOT NULL,
    fechavencimientopoliza date NOT NULL,
    indicadorcoberturaspoliza character varying(1) COLLATE pg_catalog."default" NOT NULL,
    tipopersonabeneficiario numeric(2,0) NOT NULL,
    idbeneficiario character varying(30) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_garantiaspolizas PRIMARY KEY (id_cliente, id_load, session_id, idgarantia, tipogarantia, tipobiengarantia, tipopoliza, fechavencimientopoliza)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.garantiaspolizas
    OWNER to postgres;
-- Index: idx_garantiaspolizas_id_load_local_m1

CREATE INDEX IF NOT EXISTS ix_garantiaspolizas_idx1
ON fegusdata.garantiaspolizas (
    id_cliente,
    id_load,
    idgarantia       
);  

CREATE INDEX IF NOT EXISTS ix_garantiaspolizas_idx2
ON fegusdata.garantiaspolizas (
    id_cliente,
    id_load,
    idgarantia,
    tipopoliza       
);   
