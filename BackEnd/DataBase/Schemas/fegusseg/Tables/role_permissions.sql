-- Table: fegusseg.role_permissions

-- DROP TABLE IF EXISTS fegusseg.role_permissions;

CREATE TABLE IF NOT EXISTS fegusseg.role_permissions
(
    idrolepermiss integer NOT NULL DEFAULT nextval('fegusseg.role_permissions_idrolepermiss_seq'::regclass),
    idcliente integer NOT NULL,
    idrole integer NOT NULL,
    idpermiss integer NOT NULL,
    CONSTRAINT role_permissions_pkey PRIMARY KEY (idrolepermiss),
    CONSTRAINT uk_role_permissions UNIQUE (idcliente, idrole, idpermiss),
    CONSTRAINT fk_rp_customer FOREIGN KEY (idcliente)
        REFERENCES fegusseg.customers (idcliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_rp_permission FOREIGN KEY (idpermiss)
        REFERENCES fegusseg.permissions (idpermiss) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_rp_role FOREIGN KEY (idrole)
        REFERENCES fegusseg.roles (idrole) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusseg.role_permissions
    OWNER to postgres;

COMMENT ON TABLE fegusseg.role_permissions
    IS 'Permissions assigned to roles per customer';

COMMENT ON COLUMN fegusseg.role_permissions.idrolepermiss
    IS 'Primary key of the role-permission association';

COMMENT ON COLUMN fegusseg.role_permissions.idcliente
    IS 'Customer (tenant) identifier';

COMMENT ON COLUMN fegusseg.role_permissions.idrole
    IS 'Role identifier';

COMMENT ON COLUMN fegusseg.role_permissions.idpermiss
    IS 'Permission identifier';