CREATE TABLE feguslocal.gravamenes (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    idgarantia character varying(50) NOT NULL,
    tipomitigador character varying(10) NOT NULL,
    tipodocumentolegal character varying(10) NOT NULL,
    tipogradogravamenes character varying(10) NOT NULL,
    tipopersonaacreedor character varying(2) NOT NULL,
    idacreedor character varying(50) NOT NULL,
    montogradogravamen numeric(18,2) NOT NULL,
    tipomonedamonto character varying(5) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
