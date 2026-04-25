-- SEQUENCE: fegusseg.roles_idrole_seq

-- DROP SEQUENCE IF EXISTS fegusseg.roles_idrole_seq;

CREATE SEQUENCE IF NOT EXISTS fegusseg.roles_idrole_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE fegusseg.roles_idrole_seq
    OWNED BY fegusseg.roles.idrole;

ALTER SEQUENCE fegusseg.roles_idrole_seq
    OWNER TO postgres;