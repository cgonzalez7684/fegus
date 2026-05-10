CREATE TABLE feguslocal.naturalezagasto (
    id_load_local bigint NOT NULL,
    seq bigint NOT NULL GENERATED ALWAYS AS IDENTITY (START 1 INCREMENT 1),
    idoperacioncredito character varying(50) NOT NULL,
    tiponaturalezagasto character varying(10) NOT NULL,
    porcentajenaturalezagasto numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
