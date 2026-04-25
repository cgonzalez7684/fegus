-- Table: feguslocal.operacionesnoreportadas

-- DROP TABLE IF EXISTS feguslocal.operacionesnoreportadas;

CREATE TABLE IF NOT EXISTS feguslocal.operacionesnoreportadas
(
    id_load_local bigint NOT NULL,
    tipopersona character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacion character varying(50) COLLATE pg_catalog."default" NOT NULL,
    motivoliquidacion character varying(10) COLLATE pg_catalog."default" NOT NULL,
    fechaliquidacion date NOT NULL,
    saldoprincipalliquidado numeric(18,2) NOT NULL,
    saldoproductosliquidado numeric(18,2) NOT NULL,
    idoperacionnueva character varying(50) COLLATE pg_catalog."default",
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_operacionesnoreportadas PRIMARY KEY (id_load_local, idoperacion)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.operacionesnoreportadas
    OWNER to postgres;