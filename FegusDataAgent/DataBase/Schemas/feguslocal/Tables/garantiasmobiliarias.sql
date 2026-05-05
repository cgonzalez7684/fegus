CREATE TABLE feguslocal.garantiasmobiliarias (
    id_load_local bigint NOT NULL,
    idgarantiamobiliaria character varying(50) NOT NULL,
    fechapublicidadgm date NOT NULL,
    montogarantiamobiliaria numeric(18,2) NOT NULL,
    fechavencimientogm date NOT NULL,
    fechamontoreferencia date NOT NULL,
    montoreferencia numeric(18,2) NOT NULL,
    tipomonedamontoreferencia character varying(5) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
