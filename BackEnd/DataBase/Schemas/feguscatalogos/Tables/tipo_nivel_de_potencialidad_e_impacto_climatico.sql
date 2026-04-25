CREATE TABLE feguscatalogos.tipo_nivel_de_potencialidad_e_impacto_climatico (
    codigo character varying(50) NOT NULL,
    descripcion character varying(500) NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    observaciones text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
