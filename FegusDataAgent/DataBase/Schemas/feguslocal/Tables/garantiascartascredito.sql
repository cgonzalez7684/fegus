CREATE TABLE feguslocal.garantiascartascredito (
    id_load_local bigint NOT NULL,
    idgarantiacartacredito character varying(25) NOT NULL,
    tipomitigadorcartacredito numeric(2,0) NOT NULL,
    fechaconstitucion date NOT NULL,
    fechavencimiento date,
    tipopersona numeric(2,0) NOT NULL,
    identidadcartacredito character varying(30) NOT NULL,
    valornominalgarantia numeric(20,2) NOT NULL,
    tipomonedavalornominal numeric(6,0) NOT NULL,
    tipoasignacioncalificacion numeric(1,0) NOT NULL,
    codigocalificacioncategoria numeric(2,0) NOT NULL,
    factor_y numeric(3,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
