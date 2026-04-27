CREATE TABLE feguslocal.bienesrealizablesnoreportados3 (
    id_load_local bigint NOT NULL,
    idbienrealizable character varying(50) NOT NULL,
    indicadorgarantia character varying(1) NOT NULL,
    idgarantia character varying(50) NOT NULL,
    idbien character varying(50) NOT NULL,
    tipobien character varying(10) NOT NULL,
    tipomotivobienrealizablenoreportado character varying(10) NOT NULL,
    ultimovalorcontable numeric(18,2) NOT NULL,
    valorrecuperadoneto numeric(18,2) NOT NULL,
    idoperacioncreditofinanciamiento character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
