CREATE TABLE feguslocal.operacionesbienesrealizables (
    id_load_local bigint NOT NULL,
    idbienrealizable character varying(50) NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
