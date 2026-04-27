CREATE TABLE feguslocal.operacionesnoreportadas (
    id_load_local bigint NOT NULL,
    tipopersona character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacion character varying(50) NOT NULL,
    motivoliquidacion character varying(10) NOT NULL,
    fechaliquidacion date NOT NULL,
    saldoprincipalliquidado numeric(18,2) NOT NULL,
    saldoproductosliquidado numeric(18,2) NOT NULL,
    idoperacionnueva character varying(50),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
