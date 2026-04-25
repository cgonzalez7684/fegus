-- Table: fegusseg.roles

-- DROP TABLE IF EXISTS fegusseg.roles;

CREATE TABLE IF NOT EXISTS fegusseg.roles
(
    idrole integer NOT NULL DEFAULT nextval('fegusseg.roles_idrole_seq'::regclass),
    idcliente integer NOT NULL,
    role_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    description character varying(200) COLLATE pg_catalog."default",
    is_active character varying(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT roles_pkey PRIMARY KEY (idrole),
    CONSTRAINT uk_roles_name UNIQUE (idcliente, role_name),
    CONSTRAINT fk_roles_customer FOREIGN KEY (idcliente)
        REFERENCES fegusseg.customers (idcliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusseg.roles
    OWNER to postgres;

COMMENT ON TABLE fegusseg.roles
    IS 'Security roles defined per customer for role-based access control (RBAC)';

COMMENT ON COLUMN fegusseg.roles.idrole
    IS 'Primary key of the role';

COMMENT ON COLUMN fegusseg.roles.idcliente
    IS 'Customer (tenant) identifier';

COMMENT ON COLUMN fegusseg.roles.role_name
    IS 'Role name unique per customer';

COMMENT ON COLUMN fegusseg.roles.description
    IS 'Functional description of the role';

COMMENT ON COLUMN fegusseg.roles.is_active
    IS 'Indicates whether the role is active';