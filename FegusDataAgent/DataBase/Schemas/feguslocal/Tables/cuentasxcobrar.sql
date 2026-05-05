CREATE TABLE feguslocal.cuentasxcobrar (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    idcuentacobrarasociada character varying(50) NOT NULL,
    cuentacontablecuentacobrarasociada character varying(50) NOT NULL,
    tipocatalogosugef character varying(10) NOT NULL,
    saldocuentacobrarasociada numeric(18,2) NOT NULL,
    tipomonedacuentacobrarasociada character varying(5) NOT NULL,
    diasatrasocuentacobrarasociada integer NOT NULL,
    fecharegistrocuentacobrarasociada date NOT NULL,
    fechavencimientocuentacobrarasociada date NOT NULL,
    concepto character varying(255),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
