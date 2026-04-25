CREATE TABLE feguscatalogos.tipo_beneficiario_sbd (
    codigo character varying(50) NOT NULL,
    descripcion character varying(500) NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
