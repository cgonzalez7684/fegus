-- Table: feguslocal.cuentasporcobrarnosasociadas

-- DROP TABLE IF EXISTS feguslocal.cuentasporcobrarnosasociadas;

CREATE TABLE IF NOT EXISTS feguslocal.cuentasporcobrarnosasociadas
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    idpersona character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipomonedamonto character varying(5) COLLATE pg_catalog."default" NOT NULL,
    montooriginal numeric(18,2) NOT NULL,
    tipocatalogosugef character varying(10) COLLATE pg_catalog."default" NOT NULL,
    cuentacontablesaldoprincipal character varying(50) COLLATE pg_catalog."default" NOT NULL,
    saldoprincipal numeric(18,2) NOT NULL,
    cuentacontablesaldoproductosporcobrar character varying(50) COLLATE pg_catalog."default" NOT NULL,
    saldoproductosporcobrar numeric(18,2) NOT NULL,
    fecharegistrocontable date NOT NULL,
    fechaexigibilidad date NOT NULL,
    fechavencimiento date NOT NULL,
    montoestimacionregistrada numeric(18,2) NOT NULL,
    tipodependencia character varying(10) COLLATE pg_catalog."default" NOT NULL,
    diasmora integer NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_cuentasporcobrarnosasociadas PRIMARY KEY (id_load_local, idoperacioncredito)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.cuentasporcobrarnosasociadas
    OWNER to postgres;