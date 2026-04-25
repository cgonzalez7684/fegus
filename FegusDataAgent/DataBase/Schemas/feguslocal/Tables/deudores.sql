-- Table: feguslocal.deudores

-- DROP TABLE IF EXISTS feguslocal.deudores;

CREATE TABLE IF NOT EXISTS feguslocal.deudores
(
    id_load_local bigint NOT NULL,
    tipodeudorsfn integer,
    tipopersonadeudor numeric NOT NULL,
    iddeudor character varying(30) COLLATE pg_catalog."default" NOT NULL,
    codigosectoreconomico numeric,
    tipocapacidadpago integer,
    saldototalsegmentacion numeric,
    tipocondicionespecialdeudor integer,
    fechacalificacionriesgo text COLLATE pg_catalog."default",
    tipoindicadorgeneradordivisas integer,
    tipoasignacioncalificacion integer,
    categoriacalificacion numeric,
    calificacionriesgo text COLLATE pg_catalog."default",
    codigoempresacalificadora numeric,
    indicadorvinculadoentidad character varying COLLATE pg_catalog."default",
    indicadorvinculadogrupofinanciero character varying COLLATE pg_catalog."default",
    idgrupointereseconomico numeric,
    tipocomportamientopago integer,
    tipoactividadeconomicadeudor character varying(14) COLLATE pg_catalog."default",
    tipocomportamientopagosbd integer,
    tipobeneficiariosbd integer,
    totaloperacionesreestructuradassbd integer,
    tipoindicadorgeneradordivisassbd integer,
    riesgocambiariodeudor integer,
    montoingresototaldeudor numeric,
    totalcargamensualcsd numeric,
    indicadorcsd numeric,
    indicadorcic character varying(1) COLLATE pg_catalog."default",
    saldomoramayorultmeses1421 numeric,
    nummesesmoramayor1421 integer,
    saldomoramayorultmeses1516 numeric,
    nummesesmoramayor1516 integer,
    numdiasatraso1421 integer,
    numdiasatraso1516 integer,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT deudores_pkey PRIMARY KEY (id_load_local, tipopersonadeudor, iddeudor)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.deudores
    OWNER to postgres;
-- Index: idx_deudores_id_load_local_m1

-- DROP INDEX IF EXISTS feguslocal.idx_deudores_id_load_local_m1;

CREATE INDEX IF NOT EXISTS idx_deudores_id_load_local_m1
    ON feguslocal.deudores USING btree
    (id_load_local ASC NULLS LAST)
    TABLESPACE pg_default
    WHERE id_load_local = '-1'::integer;