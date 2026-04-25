-- Table: feguslocal.cuotasatrasadas

-- DROP TABLE IF EXISTS feguslocal.cuotasatrasadas;

CREATE TABLE IF NOT EXISTS feguslocal.cuotasatrasadas
(
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipocuota character varying(10) COLLATE pg_catalog."default" NOT NULL,
    numerocuotaatrasada integer NOT NULL,
    diasatraso integer NOT NULL,
    montocuotaatrasada numeric(18,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_cuotasatrasadas PRIMARY KEY (id_load_local, idoperacioncredito, tipocuota, numerocuotaatrasada)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.cuotasatrasadas
    OWNER to postgres;