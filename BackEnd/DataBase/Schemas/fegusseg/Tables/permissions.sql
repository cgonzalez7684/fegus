-- Table: fegusseg.permissions

-- DROP TABLE IF EXISTS fegusseg.permissions;

CREATE TABLE IF NOT EXISTS fegusseg.permissions
(
    idpermiss integer NOT NULL DEFAULT nextval('fegusseg.permissions_idpermiss_seq'::regclass),
    idcliente integer NOT NULL,
    permiss_code character varying(6) COLLATE pg_catalog."default" NOT NULL,
    description character varying(500) COLLATE pg_catalog."default",
    is_active character varying(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT permissions_pkey PRIMARY KEY (idpermiss),
    CONSTRAINT uk_permissions_code UNIQUE (idcliente, permiss_code),
    CONSTRAINT fk_permissions_customer FOREIGN KEY (idcliente)
        REFERENCES fegusseg.customers (idcliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusseg.permissions
    OWNER to postgres;

COMMENT ON TABLE fegusseg.permissions
    IS 'System permissions representing atomic actions allowed in the platform';

COMMENT ON COLUMN fegusseg.permissions.idpermiss
    IS 'Primary key of the permission';

COMMENT ON COLUMN fegusseg.permissions.idcliente
    IS 'Customer (tenant) identifier';

COMMENT ON COLUMN fegusseg.permissions.permiss_code
    IS 'Short permission code used in authorization and JWT claims';

COMMENT ON COLUMN fegusseg.permissions.description
    IS 'Detailed description of the permission';

COMMENT ON COLUMN fegusseg.permissions.is_active
    IS 'Indicates whether the permission is active';