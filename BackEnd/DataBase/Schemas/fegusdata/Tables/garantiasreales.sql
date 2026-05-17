-- Table: fegusdata.garantiasreales

-- DROP TABLE IF EXISTS fegusdata.garantiasreales;

CREATE TABLE IF NOT EXISTS fegusdata.garantiasreales
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idgarantiareal character varying(25) COLLATE pg_catalog."default" NOT NULL,
    tipobiengarantiareal numeric(5,0) NOT NULL,
    montoultimatasacionterreno numeric(20,2) NOT NULL,
    montoultimatasacionnoterreno numeric(20,2) NOT NULL,
    fechaultimatasaciongarantia date NOT NULL,
    fechaultimoseguimientogarantia date NOT NULL,
    tipomonedatasacion numeric(6,0) NOT NULL,
    fechaconstruccion date,
    tipopersonatasador numeric(2,0) NOT NULL,
    idtasador character varying(30) COLLATE pg_catalog."default" NOT NULL,
    tipopersonaempresatasadora numeric(2,0),
    idempresatasadora character varying(30) COLLATE pg_catalog."default",
    indicadorpolizagarantiareal character varying(1) COLLATE pg_catalog."default" NOT NULL,
    tipocolateralreal numeric(2,0) NOT NULL,
    porcentajerecuperacioncolateralreal numeric(5,2) NOT NULL,
    tiempo numeric(2,0) NOT NULL,
    porcentajefactordescuentotiempo numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_garantiasreales PRIMARY KEY (id_cliente, id_load, session_id, idgarantiareal)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.garantiasreales
    OWNER to postgres;
-- Index: idx_garantiasreales_id_load_local_m1

CREATE INDEX IF NOT EXISTS ix_garantiasreales_idx1
ON fegusdata.garantiasreales (
    id_cliente,
    id_load,
    idgarantiareal       
);  