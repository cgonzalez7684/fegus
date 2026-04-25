-- SEQUENCE: feguslocal.seq_garantia

-- DROP SEQUENCE IF EXISTS feguslocal.seq_garantia;

CREATE SEQUENCE IF NOT EXISTS feguslocal.seq_garantia
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE feguslocal.seq_garantia
    OWNER TO postgres;