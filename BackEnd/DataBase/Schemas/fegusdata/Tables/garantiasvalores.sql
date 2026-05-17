-- Table: fegusdata.garantiasvalores

-- DROP TABLE IF EXISTS fegusdata.garantiasvalores;

CREATE TABLE IF NOT EXISTS fegusdata.garantiasvalores
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idgarantiavalor character varying(25) COLLATE pg_catalog."default" NOT NULL,
    tipoclasificacioninstrumento numeric(1,0) NOT NULL,
    tipopersona numeric(2,0),
    idemisor character varying(30) COLLATE pg_catalog."default",
    idinstrumento character varying(25) COLLATE pg_catalog."default" NOT NULL,
    serieinstrumento character varying(20) COLLATE pg_catalog."default",
    premio numeric(9,6),
    codigoisin character varying(25) COLLATE pg_catalog."default" NOT NULL,
    tipoasignacioncalificacion numeric(1,0) NOT NULL,
    categoriacalificacion numeric(1,0),
    codigocalificacionriesgo character varying(30) COLLATE pg_catalog."default",
    codigoempresacalificadora numeric(2,0),
    valorfacial numeric(20,2),
    tipomonedavalorfacial numeric(6,0),
    valormercado numeric(20,2) NOT NULL,
    tipomonedavalormercado numeric(6,0),
    fechaconstitucion date NOT NULL,
    fechavencimiento date,
    tipocolateralfinanciero numeric(2,0) NOT NULL,
    codigocalificacioninstrumento numeric(2,0) NOT NULL,
    porcentajeajusterc numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_garantiasvalores PRIMARY KEY (id_cliente, id_load, session_id, idgarantiavalor)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.garantiasvalores
    OWNER to postgres;
-- Index: idx_garantiasvalores_id_load_local_m1

CREATE INDEX IF NOT EXISTS ix_garantiasvalores_idx1
ON fegusdata.garantiasvalores (
    id_cliente,
    id_load,
    idgarantiavalor       
);  