CREATE TABLE feguslocal.cambioclimatico (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipotema character varying(10) NOT NULL,
    tiposubtema character varying(10) NOT NULL,
    tipoactividad character varying(10) NOT NULL,
    tipoambito character varying(10) NOT NULL,
    tipofuentefinanciamiento character varying(10) NOT NULL,
    tipofondofinanciamiento character varying(10) NOT NULL,
    saldomontoclimatico numeric(18,2) NOT NULL,
    codigomodalidad character varying(10) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
