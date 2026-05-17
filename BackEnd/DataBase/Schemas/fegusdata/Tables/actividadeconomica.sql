-- Table: fegusdata.actividadeconomica

-- DROP TABLE IF EXISTS fegusdata.actividadeconomica;

CREATE TABLE IF NOT EXISTS fegusdata.actividadeconomica
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipoactividadeconomica character varying(10) COLLATE pg_catalog."default" NOT NULL,
    porcentajeactividadeconomica numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_actividadeconomica PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, tipoactividadeconomica)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.actividadeconomica
    OWNER to postgres;
	
CREATE INDEX IF NOT EXISTS ix_actividadeconomica_idx1
ON fegusdata.actividadeconomica (
    id_cliente,
    id_load,
    idoperacioncredito    
);

CREATE INDEX IF NOT EXISTS ix_actividadeconomica_idx2
ON fegusdata.actividadeconomica (
    id_cliente,
    id_load,
    idoperacioncredito,
	tipoactividadeconomica);