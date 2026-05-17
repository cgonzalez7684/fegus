-- Table: fegusdata.cuentasporcobrarnosasociadas

-- DROP TABLE IF EXISTS fegusdata.cuentasporcobrarnosasociadas;

CREATE TABLE IF NOT EXISTS fegusdata.cuentasporcobrarnosasociadas
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
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
    CONSTRAINT pk_cuentasporcobrarnosasociadas PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.cuentasporcobrarnosasociadas
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_cuentasporcobrarnosasociadas_idx1
ON fegusdata.cuentasporcobrarnosasociadas (
    id_cliente,
    id_load,
    idoperacioncredito       
);      