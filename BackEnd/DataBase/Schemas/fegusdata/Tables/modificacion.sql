-- Table: fegusdata.modificacion

-- DROP TABLE IF EXISTS fegusdata.modificacion;

CREATE TABLE IF NOT EXISTS fegusdata.modificacion
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fechamodificacion date NOT NULL,
    tipomodificacion character varying(10) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_modificacion PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, tipomodificacion)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.modificacion
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_modificacion_idx1
ON fegusdata.modificacion (
    id_cliente,
    id_load,
    idoperacioncredito       
);  

CREATE INDEX IF NOT EXISTS ix_modificacion_idx2
ON fegusdata.modificacion (
    id_cliente,
    id_load,
    idoperacioncredito,
    tipomodificacion       
);  