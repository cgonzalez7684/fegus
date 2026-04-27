CREATE TABLE feguslocal.creditossindicados (
    id_load_local bigint NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipopersona character varying(2) NOT NULL,
    identidadcreditosindicado character varying(50) NOT NULL,
    idoperacioncreditoentidadcreditosindicado character varying(50) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
