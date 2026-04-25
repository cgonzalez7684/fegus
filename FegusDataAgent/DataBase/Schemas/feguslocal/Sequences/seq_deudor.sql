-- SEQUENCE: feguslocal.seq_deudor

-- DROP SEQUENCE IF EXISTS feguslocal.seq_deudor;

CREATE SEQUENCE IF NOT EXISTS feguslocal.seq_deudor
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE feguslocal.seq_deudor
    OWNER TO postgres;