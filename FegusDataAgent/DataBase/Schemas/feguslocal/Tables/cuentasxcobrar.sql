-- Table: feguslocal.cuentasxcobrar

-- DROP TABLE IF EXISTS feguslocal.cuentasxcobrar;

CREATE TABLE IF NOT EXISTS feguslocal.cuentasxcobrar
(
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idcuentacobrarasociada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    cuentacontablecuentacobrarasociada character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipocatalogosugef character varying(10) COLLATE pg_catalog."default" NOT NULL,
    saldocuentacobrarasociada numeric(18,2) NOT NULL,
    tipomonedacuentacobrarasociada character varying(5) COLLATE pg_catalog."default" NOT NULL,
    diasatrasocuentacobrarasociada integer NOT NULL,
    fecharegistrocuentacobrarasociada date NOT NULL,
    fechavencimientocuentacobrarasociada date NOT NULL,
    concepto character varying(255) COLLATE pg_catalog."default",
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,
    CONSTRAINT pk_cuentasxcobrar PRIMARY KEY (id_load_local, idoperacioncredito, idcuentacobrarasociada)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS feguslocal.cuentasxcobrar
    OWNER to postgres;