-- Table: fegusseg.refresh_tokens

-- DROP TABLE IF EXISTS fegusseg.refresh_tokens;

CREATE TABLE IF NOT EXISTS fegusseg.refresh_tokens
(
    id_refresh_token integer NOT NULL DEFAULT nextval('fegusseg.refresh_tokens_id_refresh_token_seq'::regclass),
    idcliente integer NOT NULL,
    iduser integer NOT NULL,
    token text COLLATE pg_catalog."default" NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    is_revoked boolean NOT NULL DEFAULT false,
    created_at timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ip text COLLATE pg_catalog."default",
    user_agent text COLLATE pg_catalog."default",
    CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id_refresh_token),
    CONSTRAINT fk_rt_user FOREIGN KEY (iduser)
        REFERENCES fegusseg.users (iduser) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusseg.refresh_tokens
    OWNER to postgres;

COMMENT ON TABLE fegusseg.refresh_tokens
    IS 'Tokens refresh for users';

COMMENT ON COLUMN fegusseg.refresh_tokens.idcliente
    IS 'Customer (tenant) identifier';

COMMENT ON COLUMN fegusseg.refresh_tokens.iduser
    IS 'Primary key of the user';

COMMENT ON COLUMN fegusseg.refresh_tokens.token
    IS 'Tokens users';

COMMENT ON COLUMN fegusseg.refresh_tokens.expires_at
    IS 'Expires date token';

COMMENT ON COLUMN fegusseg.refresh_tokens.is_revoked
    IS 'Token is rovoked';

COMMENT ON COLUMN fegusseg.refresh_tokens.created_at
    IS 'Ip machine from request the token';

COMMENT ON COLUMN fegusseg.refresh_tokens.user_agent
    IS 'User agent machine from request the token';