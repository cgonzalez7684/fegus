-- Table: feguslocal.garantiasoperacion

-- DROP TABLE IF EXISTS feguslocal.garantiasoperacion;

CREATE TABLE IF NOT EXISTS feguslocal.garantiasoperacion
(
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipogarantia character varying(10) COLLATE pg_catalog."default" NOT NULL,
    idgarantia character varying(50) COLLATE pg_catalog."default" NOT NULL,
    indicadorformatraspasobien character varying(1) COLLATE pg_catalog."default" NOT NULL,
    idgarantiatraspaso character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipomitigador character varying(10) COLLATE pg_catalog."default" NOT NULL,
    tipodocumentolegal character varying(10) COLLATE pg_catalog."default" NOT NULL,
    valorajustadogarantia numeric(18,2) NOT NULL,
    tipoinscripciongarantia character varying(10) COLLATE pg_catalog."default" NOT NULL,
    porcentajeresponsabilidadgarantia numeric(5,2) NOT NULL,
    valornominalgarantia numeric(18,2) NOT NULL,
    fechapresentacionregistrogarantia date,
    tipomonedavalornominalgarantia character varying(5) COLLATE pg_catalog."default",
    fechaconstituciongarantia date,
    fechavencimientogarantia date,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_garantiasoperacion PRIMARY KEY (id_load_local, idoperacioncredito, tipopersonadeudor, iddeudor, idgarantia, tipomitigador, tipodocumentolegal)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.garantiasoperacion
    OWNER to postgres;