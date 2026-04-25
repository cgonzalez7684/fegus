-- SEQUENCE: fegusseg.users_iduser_seq

-- DROP SEQUENCE IF EXISTS fegusseg.users_iduser_seq;

CREATE SEQUENCE IF NOT EXISTS fegusseg.users_iduser_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE fegusseg.users_iduser_seq
    OWNED BY fegusseg.users.iduser;

ALTER SEQUENCE fegusseg.users_iduser_seq
    OWNER TO postgres;