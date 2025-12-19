-- Table: fegusdata.deudores

-- DROP TABLE IF EXISTS fegusdata.deudores;

CREATE TABLE IF NOT EXISTS fegusdata.deudores
(
    "Id_Cliente" integer NOT NULL,
    tipodeudorsfn integer NOT NULL,
    "TipoPersonaDeudor" numeric NOT NULL,
    "IdDeudor" character varying(30) COLLATE pg_catalog."default" NOT NULL,
    "CodigoSectorEconomico" numeric NOT NULL,
    "TipoCapacidadPago" integer NOT NULL,
    "SaldoTotalSegmentacion" numeric,
    "TipoCondicionEspecialDeudor" integer,
    "FechaCalificacionRiesgo" text COLLATE pg_catalog."default" NOT NULL,
    "TipoIndicadorGeneradorDivisas" integer NOT NULL,
    "TipoAsignacionCalificacion" integer NOT NULL,
    "CategoriaCalificacion" numeric,
    "CalificacionRiesgo" text COLLATE pg_catalog."default",
    "CodigoEmpresaCalificadora" numeric,
    "IndicadorVinculadoEntidad" character varying COLLATE pg_catalog."default" NOT NULL,
    "IndicadorVinculadoGrupoFinanciero" character varying COLLATE pg_catalog."default" NOT NULL,
    "IdGrupoInteresEconomico" numeric,
    "TipoComportamientoPago" integer NOT NULL,
    "TipoActividadEconomicaDeudor" character varying(14) COLLATE pg_catalog."default" NOT NULL,
    "TipoComportamientoPagoSBD" integer NOT NULL,
    "TipoBeneficiarioSBD" integer NOT NULL,
    "TotalOperacionesRestructuradasSBD" integer NOT NULL,
    "TipoIndicadorGeneradorDivisasSBD" integer NOT NULL,
    "RiesgoCambiarioDeudor" integer NOT NULL,
    "MontoIngresoTotalDeudor" numeric NOT NULL,
    "TotalCargaMensualCSD" numeric NOT NULL,
    "IndicadorCSD" numeric NOT NULL,
    "FechaUltGestion" date NOT NULL,
    "CodUsuarioUltGestion" character varying(50) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT deudores_pkey PRIMARY KEY ("Id_Cliente", "TipoPersonaDeudor", "IdDeudor")
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS fegusdata.deudores
    OWNER to postgres;