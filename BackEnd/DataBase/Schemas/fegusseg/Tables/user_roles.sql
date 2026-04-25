-- Table: fegusseg.user_roles

-- DROP TABLE IF EXISTS fegusseg.user_roles;

CREATE TABLE IF NOT EXISTS fegusseg.user_roles
(
    iduserrole integer NOT NULL DEFAULT nextval('fegusseg.user_roles_iduserrole_seq'::regclass),
    idcliente integer NOT NULL,
    iduser integer NOT NULL,
    idrole integer NOT NULL,
    CONSTRAINT user_roles_pkey PRIMARY KEY (iduserrole),
    CONSTRAINT uk_user_roles UNIQUE (idcliente, iduser, idrole),
    CONSTRAINT fk_ur_customer FOREIGN KEY (idcliente)
        REFERENCES fegusseg.customers (idcliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_ur_role FOREIGN KEY (idrole)
        REFERENCES fegusseg.roles (idrole) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_ur_user FOREIGN KEY (iduser)
        REFERENCES fegusseg.users (iduser) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusseg.user_roles
    OWNER to postgres;

COMMENT ON TABLE fegusseg.user_roles
    IS 'Association between users and roles per customer';

COMMENT ON COLUMN fegusseg.user_roles.iduserrole
    IS 'Primary key of the user-role association';

COMMENT ON COLUMN fegusseg.user_roles.idcliente
    IS 'Customer (tenant) identifier';

COMMENT ON COLUMN fegusseg.user_roles.iduser
    IS 'User identifier';

COMMENT ON COLUMN fegusseg.user_roles.idrole
    IS 'Role identifier assigned to the user';