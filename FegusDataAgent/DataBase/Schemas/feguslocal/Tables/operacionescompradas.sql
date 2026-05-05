CREATE TABLE feguslocal.operacionescompradas (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersonaentidadoperacion character varying(2) NOT NULL,
    identidadoperacioncomprada character varying(50) NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudorcomprada character varying(50) NOT NULL,
    idoperacioncreditocomprada character varying(50) NOT NULL,
    fechadesembolsodeudor date NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
