-- Table: feguslocal.modificacion

-- DROP TABLE IF EXISTS feguslocal.modificacion;

CREATE TABLE IF NOT EXISTS feguslocal.modificacion
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    fechamodificacion date NOT NULL,
    tipomodificacion character varying(10) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_modificacion PRIMARY KEY (id_load_local, idoperacioncredito, tipomodificacion)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.modificacion
    OWNER to postgres;