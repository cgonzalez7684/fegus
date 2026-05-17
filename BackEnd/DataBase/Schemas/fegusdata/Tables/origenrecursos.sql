-- Table: fegusdata.origenrecursos

-- DROP TABLE IF EXISTS fegusdata.origenrecursos;

CREATE TABLE IF NOT EXISTS fegusdata.origenrecursos
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipoorigenrecursos character varying(10) COLLATE pg_catalog."default" NOT NULL,
    porcentajeorigenrecursos numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_origenrecursos PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, tipoorigenrecursos)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.origenrecursos
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_origenrecursos_idx1
ON fegusdata.origenrecursos (
    id_cliente,
    id_load,
    idoperacioncredito       
);      

CREATE INDEX IF NOT EXISTS ix_origenrecursos_idx2
ON fegusdata.origenrecursos (
    id_cliente,
    id_load,
    idoperacioncredito,
    tipoorigenrecursos       
);  