-- SEQUENCE: fegusseg.permissions_idpermiss_seq

-- DROP SEQUENCE IF EXISTS fegusseg.permissions_idpermiss_seq;

CREATE SEQUENCE IF NOT EXISTS fegusseg.permissions_idpermiss_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE fegusseg.permissions_idpermiss_seq
    OWNED BY fegusseg.permissions.idpermiss;

ALTER SEQUENCE fegusseg.permissions_idpermiss_seq
    OWNER TO postgres;