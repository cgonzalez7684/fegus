-- Table: fegusseg.user_permissions

-- DROP TABLE IF EXISTS fegusseg.user_permissions;

CREATE TABLE IF NOT EXISTS fegusseg.user_permissions
(
    iduserpermiss integer NOT NULL DEFAULT nextval('fegusseg.user_permissions_iduserpermiss_seq'::regclass),
    idcliente integer NOT NULL,
    iduser integer NOT NULL,
    idpermiss integer NOT NULL,
    CONSTRAINT user_permissions_pkey PRIMARY KEY (iduserpermiss),
    CONSTRAINT uk_user_permissions UNIQUE (idcliente, iduser, idpermiss),
    CONSTRAINT fk_up_customer FOREIGN KEY (idcliente)
        REFERENCES fegusseg.customers (idcliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_up_permission FOREIGN KEY (idpermiss)
        REFERENCES fegusseg.permissions (idpermiss) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_up_user FOREIGN KEY (iduser)
        REFERENCES fegusseg.users (iduser) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusseg.user_permissions
    OWNER to postgres;

COMMENT ON TABLE fegusseg.user_permissions
    IS 'Direct permissions assigned to users overriding role permissions';

COMMENT ON COLUMN fegusseg.user_permissions.iduserpermiss
    IS 'Primary key of the user-permission association';

COMMENT ON COLUMN fegusseg.user_permissions.idcliente
    IS 'Customer (tenant) identifier';

COMMENT ON COLUMN fegusseg.user_permissions.iduser
    IS 'User identifier';

COMMENT ON COLUMN fegusseg.user_permissions.idpermiss
    IS 'Permission identifier';