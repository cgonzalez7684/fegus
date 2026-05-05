CREATE TABLE feguslocal.origenrecursos (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipoorigenrecursos character varying(10) NOT NULL,
    porcentajeorigenrecursos numeric(5,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
