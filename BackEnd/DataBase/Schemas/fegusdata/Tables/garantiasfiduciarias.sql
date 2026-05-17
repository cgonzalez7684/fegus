-- Table: fegusdata.garantiasfiduciarias

-- DROP TABLE IF EXISTS fegusdata.garantiasfiduciarias;

CREATE TABLE IF NOT EXISTS fegusdata.garantiasfiduciarias
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idgarantiafiduciaria character varying(25) COLLATE pg_catalog."default" NOT NULL,
    tipopersona numeric(2,0) NOT NULL,
    idfiador character varying(30) COLLATE pg_catalog."default" NOT NULL,
    salarionetofiador numeric(20,2),
    fechaverificacionasalariado date,
    montoavalado numeric(20,2),
    porcentajemitigacionfondo numeric(5,2),
    porcentajeestimacionminimofondo numeric(5,2),
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_garantiasfiduciarias PRIMARY KEY (id_cliente, id_load, session_id, idgarantiafiduciaria)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.garantiasfiduciarias
    OWNER to postgres;
-- Index: idx_garantiasfiduciarias_id_load_local_m1

-- DROP INDEX IF EXISTS fegusdata.idx_garantiasfiduciarias_id_load_local_m1;

CREATE INDEX IF NOT EXISTS ix_garantiasfiduciarias_idx1
ON fegusdata.garantiasfiduciarias (
    id_cliente,
    id_load,
    idgarantiafiduciaria       
); 