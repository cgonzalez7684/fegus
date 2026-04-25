-- SEQUENCE: feguslocal.seq_operacion

-- DROP SEQUENCE IF EXISTS feguslocal.seq_operacion;

CREATE SEQUENCE IF NOT EXISTS feguslocal.seq_operacion
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE feguslocal.seq_operacion
    OWNER TO postgres;