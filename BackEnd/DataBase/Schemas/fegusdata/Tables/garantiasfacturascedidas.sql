-- Table: fegusdata.garantiasfacturascedidas

-- DROP TABLE IF EXISTS fegusdata.garantiasfacturascedidas;

CREATE TABLE IF NOT EXISTS fegusdata.garantiasfacturascedidas
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idgarantiafacturacedida character varying(25) COLLATE pg_catalog."default" NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date,
    tipopersona numeric(2,0) NOT NULL,
    idobligado character varying(30) COLLATE pg_catalog."default" NOT NULL,
    valornominalgarantia numeric(20,2) NOT NULL,
    tipomonedavalornominal numeric(6,0) NOT NULL,
    porcentajeajusterc numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_garantiasfacturascedidas PRIMARY KEY (id_cliente, id_load, session_id, idgarantiafacturacedida)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.garantiasfacturascedidas
    OWNER to postgres;
-- Index: idx_garantiasfacturascedidas_id_load_local_m1

-- DROP INDEX IF EXISTS fegusdata.idx_garantiasfacturascedidas_id_load_local_m1;

CREATE INDEX IF NOT EXISTS ix_garantiasfacturascedidas_idx1
ON fegusdata.garantiasfacturascedidas (
    id_cliente,
    id_load,
    idgarantiafacturacedida       
); 