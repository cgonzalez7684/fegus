CREATE TABLE feguslocal.garantiasfiduciarias (
    id_load_local bigint NOT NULL,
    idgarantiafiduciaria character varying(25) NOT NULL,
    tipopersona numeric(2,0) NOT NULL,
    idfiador character varying(30) NOT NULL,
    salarionetofiador numeric(20,2),
    fechaverificacionasalariado date,
    montoavalado numeric(20,2),
    porcentajemitigacionfondo numeric(5,2),
    porcentajeestimacionminimofondo numeric(5,2),
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
