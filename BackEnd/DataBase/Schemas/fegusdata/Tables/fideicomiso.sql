-- Table: fegusdata.fideicomiso

-- DROP TABLE IF EXISTS fegusdata.fideicomiso;

CREATE TABLE IF NOT EXISTS fegusdata.fideicomiso
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idfideicomisogarantia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date NOT NULL,
    valornominalfideicomiso numeric(18,2) NOT NULL,
    tipomonedavalornominalfideicomiso character varying(5) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_fideicomiso PRIMARY KEY (id_cliente, id_load, session_id, idfideicomisogarantia)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.fideicomiso
    OWNER to postgres;


CREATE INDEX IF NOT EXISTS ix_fideicomiso_idx1
ON fegusdata.fideicomiso (
    id_cliente,
    id_load,
    idfideicomisogarantia       
);     