CREATE TABLE feguslocal.codeudores (
    id_load_local bigint NOT NULL,
    seq bigint NOT NULL GENERATED ALWAYS AS IDENTITY (START 1 INCREMENT 1),
    idoperacioncredito character varying(50) NOT NULL,
    tipopersonacodeudor character varying(2) NOT NULL,
    idcodeudor character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
