-- Table: feguslocal.origenrecursos

-- DROP TABLE IF EXISTS feguslocal.origenrecursos;

CREATE TABLE IF NOT EXISTS feguslocal.origenrecursos
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipoorigenrecursos character varying(10) COLLATE pg_catalog."default" NOT NULL,
    porcentajeorigenrecursos numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_origenrecursos PRIMARY KEY (id_load_local, idoperacioncredito, tipoorigenrecursos)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.origenrecursos
    OWNER to postgres;