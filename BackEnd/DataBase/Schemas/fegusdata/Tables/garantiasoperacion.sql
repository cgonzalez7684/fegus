-- Table: fegusdata.garantiasoperacion

-- DROP TABLE IF EXISTS fegusdata.garantiasoperacion;

CREATE TABLE IF NOT EXISTS fegusdata.garantiasoperacion
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
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
    CONSTRAINT pk_garantiasoperacion PRIMARY KEY (id_cliente, id_load, session_id, seq, idoperacioncredito, tipopersonadeudor, iddeudor, idgarantia, tipomitigador, tipodocumentolegal)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.garantiasoperacion
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_garantiasoperacion_idx1
ON fegusdata.garantiasoperacion (
    id_cliente,
    id_load,
    idoperacioncredito       
);     

CREATE INDEX IF NOT EXISTS ix_garantiasoperacion_idx2
ON fegusdata.garantiasoperacion (
    id_cliente,
    id_load,
    idoperacioncredito,  
    tipopersonadeudor, 
    iddeudor, 
    idgarantia, 
    tipomitigador, 
    tipodocumentolegal     
);  

CREATE INDEX IF NOT EXISTS ix_garantiasoperacion_idx3
ON fegusdata.garantiasoperacion (
    id_cliente,
    id_load,
    idoperacioncredito,       
    iddeudor 
);  

CREATE INDEX IF NOT EXISTS ix_garantiasoperacion_idx4
ON fegusdata.garantiasoperacion (
    id_cliente,
    id_load,
    idoperacioncredito,       
    idgarantia 
); 