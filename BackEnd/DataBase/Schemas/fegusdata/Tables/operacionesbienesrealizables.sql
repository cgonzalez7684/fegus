-- Table: fegusdata.operacionesbienesrealizables

-- DROP TABLE IF EXISTS fegusdata.operacionesbienesrealizables;

CREATE TABLE IF NOT EXISTS fegusdata.operacionesbienesrealizables
(
    id_cliente integer NOT NULL,
	id_load bigint NOT NULL,
	session_id uuid NOT NULL,
	seq bigint NOT NULL,
    idbienrealizable character varying(50) COLLATE pg_catalog."default" NOT NULL,
    tipopersonadeudor character varying(2) COLLATE pg_catalog."default" NOT NULL,
    iddeudor character varying(50) COLLATE pg_catalog."default" NOT NULL,
    idoperacioncredito character varying(50) COLLATE pg_catalog."default" NOT NULL,
    created_at_utc timestamp without time zone NOT NULL DEFAULT now(),
    updated_at_utc timestamp without time zone,    
    CONSTRAINT pk_operacionesbienesrealizables PRIMARY KEY (id_cliente, id_load, session_id, tipopersonadeudor, iddeudor, idoperacioncredito, idbienrealizable)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.operacionesbienesrealizables
    OWNER to postgres;

CREATE INDEX IF NOT EXISTS ix_operacionesbienesrealizables_idx1
ON fegusdata.operacionesbienesrealizables (
    id_cliente,
    id_load,
    idoperacioncredito       
);   

CREATE INDEX IF NOT EXISTS ix_operacionesbienesrealizables_idx2
ON fegusdata.operacionesbienesrealizables (
    id_cliente,
    id_load,
    idoperacioncredito ,
    iddeudor, 
    idbienrealizable      
);  

CREATE INDEX IF NOT EXISTS ix_operacionesbienesrealizables_idx3
ON fegusdata.operacionesbienesrealizables (
    id_cliente,
    id_load,
    idoperacioncredito ,
    iddeudor          
);   

CREATE INDEX IF NOT EXISTS ix_operacionesbienesrealizables_idx4
ON fegusdata.operacionesbienesrealizables (
    id_cliente,
    id_load,
    idoperacioncredito ,     
    idbienrealizable      
);

CREATE INDEX IF NOT EXISTS ix_operacionesbienesrealizables_idx5
ON fegusdata.operacionesbienesrealizables (
    id_cliente,
    id_load,
    iddeudor,     
    idbienrealizable      
); 