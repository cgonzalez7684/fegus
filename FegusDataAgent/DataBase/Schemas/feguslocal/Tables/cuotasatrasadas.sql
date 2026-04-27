CREATE TABLE feguslocal.cuotasatrasadas (
    id_load_local bigint NOT NULL,
    tipopersonadeudor character varying(2) NOT NULL,
    iddeudor character varying(50) NOT NULL,
    idoperacioncredito character varying(50) NOT NULL,
    tipocuota character varying(10) NOT NULL,
    numerocuotaatrasada integer NOT NULL,
    diasatraso integer NOT NULL,
    montocuotaatrasada numeric(18,2) NOT NULL,
    created_at_utc timestamp without time zone DEFAULT now() NOT NULL,
    updated_at_utc timestamp without time zone
);
