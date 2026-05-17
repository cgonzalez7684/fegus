-- Table: fegusdata.garantiascartascredito

-- DROP TABLE IF EXISTS fegusdata.garantiascartascredito;

CREATE TABLE IF NOT EXISTS fegusdata.garantiascartascredito
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idgarantiacartacredito character varying(25) COLLATE pg_catalog."default" NOT NULL,
    tipomitigadorcartacredito numeric(2,0) NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date,
    tipopersona numeric(2,0) NOT NULL,
    identidadcartacredito character varying(30) COLLATE pg_catalog."default" NOT NULL,
    valornominalgarantia numeric(20,2) NOT NULL,
    tipomonedavalornominal numeric(6,0) NOT NULL,
    tipoasignacioncalificacion numeric(1,0) NOT NULL,
    codigocalificacioncategoria numeric(2,0) NOT NULL,
    factor_y numeric(3,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_garantiascartascredito PRIMARY KEY (id_cliente, id_load, session_id,  idgarantiacartacredito)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.garantiascartascredito
    OWNER to postgres;
-- Index: idx_garantiascartascredito_id_load_local_m1

-- DROP INDEX IF EXISTS fegusdata.idx_garantiascartascredito_id_load_local_m1;

CREATE INDEX IF NOT EXISTS ix_garantiascartascredito_idx1
ON fegusdata.garantiascartascredito (
    id_cliente,
    id_load,
    idgarantiacartacredito       
); 