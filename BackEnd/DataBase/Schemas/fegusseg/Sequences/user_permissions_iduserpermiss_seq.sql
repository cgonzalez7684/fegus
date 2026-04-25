-- SEQUENCE: fegusseg.user_permissions_iduserpermiss_seq

-- DROP SEQUENCE IF EXISTS fegusseg.user_permissions_iduserpermiss_seq;

CREATE SEQUENCE IF NOT EXISTS fegusseg.user_permissions_iduserpermiss_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE fegusseg.user_permissions_iduserpermiss_seq
    OWNED BY fegusseg.user_permissions.iduserpermiss;

ALTER SEQUENCE fegusseg.user_permissions_iduserpermiss_seq
    OWNER TO postgres;