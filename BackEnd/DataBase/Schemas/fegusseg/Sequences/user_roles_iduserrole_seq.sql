-- SEQUENCE: fegusseg.user_roles_iduserrole_seq

-- DROP SEQUENCE IF EXISTS fegusseg.user_roles_iduserrole_seq;

CREATE SEQUENCE IF NOT EXISTS fegusseg.user_roles_iduserrole_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE fegusseg.user_roles_iduserrole_seq
    OWNED BY fegusseg.user_roles.iduserrole;

ALTER SEQUENCE fegusseg.user_roles_iduserrole_seq
    OWNER TO postgres;