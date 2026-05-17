-- Table: fegusdata.cuentasxcobrar

-- DROP TABLE IF EXISTS fegusdata.cuentasxcobrar;

CREATE TABLE IF NOT EXISTS fegusdata.cuentasxcobrar
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
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
    CONSTRAINT pk_cuentasxcobrar PRIMARY KEY (id_cliente, id_load, session_id, idoperacioncredito, idcuentacobrarasociada)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.cuentasxcobrar
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_cuentasxcobrar_idx1
ON fegusdata.cuentasxcobrar (
    id_cliente,
    id_load,
    idoperacioncredito       
);   

CREATE INDEX IF NOT EXISTS ix_cuentasxcobrar_idx2
ON fegusdata.cuentasxcobrar (
    id_cliente,
    id_load,
    idoperacioncredito ,
    idcuentacobrarasociada      
);  