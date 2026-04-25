-- Table: feguslocal.operacionesbienesrealizables

-- DROP TABLE IF EXISTS feguslocal.operacionesbienesrealizables;

CREATE TABLE IF NOT EXISTS feguslocal.operacionesbienesrealizables
(
    id_load_local bigint NOT NULL,
    idbienrealizable character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_operacionesbienesrealizables PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor, idoperacioncredito, idbienrealizable)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.operacionesbienesrealizables
    OWNER to postgres;