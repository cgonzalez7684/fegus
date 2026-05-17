-- Table: fegusdata.deudores

-- DROP TABLE IF EXISTS fegusdata.deudores;

CREATE TABLE IF NOT EXISTS fegusdata.deudores
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
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
    CONSTRAINT deudores_pkey PRIMARY KEY (id_cliente, id_load, session_id, tipopersonadeudor, iddeudor)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.deudores
    OWNER to postgres;


CREATE INDEX IF NOT EXISTS ix_deudores_idx1
ON fegusdata.deudores (
    id_cliente,
    id_load,
    tipopersonadeudor,
    iddeudor    
);

CREATE INDEX IF NOT EXISTS ix_deudores_idx2
ON fegusdata.deudores (
    id_cliente,
    id_load,    
    iddeudor
);

