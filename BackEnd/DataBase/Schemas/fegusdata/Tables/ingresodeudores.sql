-- Table: fegusdata.ingresodeudores

-- DROP TABLE IF EXISTS fegusdata.ingresodeudores;

CREATE TABLE IF NOT EXISTS fegusdata.ingresodeudores
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipoingresodeudor character varying(10) COLLATE pg_catalog."default" NOT NULL,
    montoingresodeudor numeric(18,2) NOT NULL,
    tipomonedaingreso character varying(5) COLLATE pg_catalog."default" NOT NULL,
    fechaverificacioningreso date,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_ingresodeudores PRIMARY KEY (id_cliente, id_load, session_id, tipopersonadeudor, iddeudor, tipoingresodeudor, tipomonedaingreso)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.ingresodeudores
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_ingresodeudores_idx1
ON fegusdata.ingresodeudores (
    id_cliente,
    id_load,
    iddeudor       
);      