-- Type: deudores_type

-- DROP TYPE IF EXISTS feguslocal.deudores_type;

CREATE TYPE feguslocal.deudores_type AS
(
	id_load_local bigint,
	tipodeudorsfn integer,
	tipopersonadeudor numeric,
	iddeudor character varying(30),
	codigosectoreconomico numeric,
	tipocapacidadpago integer,
	saldototalsegmentacion numeric,
	tipocondicionespecialdeudor integer,
	fechacalificacionriesgo text,
	tipoindicadorgeneradordivisas integer,
	tipoasignacioncalificacion integer,
	categoriacalificacion numeric,
	calificacionriesgo text,
	codigoempresacalificadora numeric,
	indicadorvinculadoentidad character varying,
	indicadorvinculadogrupofinanciero character varying,
	idgrupointereseconomico numeric,
	tipocomportamientopago integer,
	tipoactividadeconomicadeudor character varying(14),
	tipocomportamientopagosbd integer,
	tipobeneficiariosbd integer,
	totaloperacionesreestructuradassbd integer,
	tipoindicadorgeneradordivisassbd integer,
	riesgocambiariodeudor integer,
	montoingresototaldeudor numeric,
	totalcargamensualcsd numeric,
	indicadorcsd numeric,
	indicadorcic character varying(1),
	saldomoramayorultmeses1421 numeric,
	nummesesmoramayor1421 integer,
	saldomoramayorultmeses1516 numeric,
	nummesesmoramayor1516 integer,
	numdiasatraso1421 integer,
	numdiasatraso1516 integer,
	created_at_utc timestamp without time zone,
	updated_at_utc timestamp without time zone
);

ALTER TYPE feguslocal.deudores_type
    OWNER TO postgres;
