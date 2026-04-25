-- SEQUENCE: fegusseg.role_permissions_idrolepermiss_seq

-- DROP SEQUENCE IF EXISTS fegusseg.role_permissions_idrolepermiss_seq;

CREATE SEQUENCE IF NOT EXISTS fegusseg.role_permissions_idrolepermiss_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE fegusseg.role_permissions_idrolepermiss_seq
    OWNED BY fegusseg.role_permissions.idrolepermiss;

ALTER SEQUENCE fegusseg.role_permissions_idrolepermiss_seq
    OWNER TO postgres;