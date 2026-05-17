-- Table: fegusdata.gravamenes

-- DROP TABLE IF EXISTS fegusdata.gravamenes;

CREATE TABLE IF NOT EXISTS fegusdata.gravamenes
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idgarantia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipomitigador character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipodocumentolegal character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipogradogravamenes character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipopersonaacreedor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    idacreedor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    montogradogravamen numeric(18,2) NOT NULL,
    tipomonedamonto character varying(5) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_gravamenes PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, idgarantia, tipomitigador, tipodocumentolegal, tipogradogravamenes, tipopersonaacreedor, idacreedor)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.gravamenes
    OWNER to postgres;


CREATE INDEX IF NOT EXISTS ix_gravamenes_idx1
ON fegusdata.gravamenes (
    id_cliente,
    id_load,
    idoperacioncredito       
);   

CREATE INDEX IF NOT EXISTS ix_gravamenes_idx2
ON fegusdata.gravamenes (
    id_cliente,
    id_load,
    idgarantia       
);  

CREATE INDEX IF NOT EXISTS ix_gravamenes_idx3
ON fegusdata.gravamenes (
    id_cliente,
    id_load,
    idoperacioncredito,
    idgarantia       
);  