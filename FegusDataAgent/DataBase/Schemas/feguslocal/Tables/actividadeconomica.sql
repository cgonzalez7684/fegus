-- Table: feguslocal.actividadeconomica

-- DROP TABLE IF EXISTS feguslocal.actividadeconomica;

CREATE TABLE IF NOT EXISTS feguslocal.actividadeconomica
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipoactividadeconomica character varying(10) COLLATE pg_catalog."default" NOT NULL,
    porcentajeactividadeconomica numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_actividadeconomica PRIMARY KEY (id_load_local, idoperacioncredito, tipoactividadeconomica)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.actividadeconomica
    OWNER to postgres;