-- Table: fegusseg.users

-- DROP TABLE IF EXISTS fegusseg.users;

CREATE TABLE IF NOT EXISTS fegusseg.users
(
    iduser integer NOT NULL DEFAULT nextval('fegusseg.users_iduser_seq'::regclass),
    idcliente integer NOT NULL,
    user_name character varying(30) COLLATE pg_catalog."default" NOT NULL,
    user_email character varying(150) COLLATE pg_catalog."default" NOT NULL,
    pass_hash text COLLATE pg_catalog."default" NOT NULL,
    status character varying(1) COLLATE pg_catalog."default",
    is_active character varying(1) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT users_pkey PRIMARY KEY (iduser),
    CONSTRAINT uk_users_email UNIQUE (idcliente, user_email),
    CONSTRAINT uk_users_username UNIQUE (idcliente, user_name),
    CONSTRAINT fk_users_customer FOREIGN KEY (idcliente)
        REFERENCES fegusseg.customers (idcliente) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusseg.users
    OWNER to postgres;

COMMENT ON TABLE fegusseg.users
    IS 'Application users associated with a specific customer (tenant)';

COMMENT ON COLUMN fegusseg.users.iduser
    IS 'Primary key of the user';

COMMENT ON COLUMN fegusseg.users.idcliente
    IS 'Customer (tenant) identifier';

COMMENT ON COLUMN fegusseg.users.user_name
    IS 'Login username unique per customer';

COMMENT ON COLUMN fegusseg.users.user_email
    IS 'User email address unique per customer';

COMMENT ON COLUMN fegusseg.users.pass_hash
    IS 'Secure hash of the user password';

COMMENT ON COLUMN fegusseg.users.status
    IS 'User status (A=Active, L=Locked, I=Inactive)';

COMMENT ON COLUMN fegusseg.users.is_active
    IS 'Indicates whether the user record is active';