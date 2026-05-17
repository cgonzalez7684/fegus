-- Table: fegusdata.cuotasatrasadas

-- DROP TABLE IF EXISTS fegusdata.cuotasatrasadas;

CREATE TABLE IF NOT EXISTS fegusdata.cuotasatrasadas
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipocuota character varying(10) COLLATE pg_catalog."default" NOT NULL,
    numerocuotaatrasada integer NOT NULL,
    diasatraso integer NOT NULL,
    montocuotaatrasada numeric(18,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_cuotasatrasadas PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, tipocuota, numerocuotaatrasada)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.cuotasatrasadas
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_cuotasatrasadas_idx1
ON fegusdata.cuotasatrasadas (
    id_cliente,
    id_load,
    idoperacioncredito       
);      