TRUNCATE TABLE
    fegusconfig.fe_ingestion_actividadeconomica_raw,
    fegusconfig.fe_ingestion_bienesrealizables_raw,
    fegusconfig.fe_ingestion_bienesrealizablesnoreportados_raw,
    fegusconfig.fe_ingestion_cambioclimatico_raw,
    fegusconfig.fe_ingestion_codeudores_raw,
    fegusconfig.fe_ingestion_creditossindicados_raw,
    fegusconfig.fe_ingestion_cuentas_cobrar_asociadas_raw,
    fegusconfig.fe_ingestion_cuentasporcobrarnosasociadas_raw,
    fegusconfig.fe_ingestion_cuotas_atrasadas_raw,
    fegusconfig.fe_ingestion_deudores_raw,
    fegusconfig.fe_ingestion_fideicomiso_raw,
    fegusconfig.fe_ingestion_garantias_raw,
    fegusconfig.fe_ingestion_garantiascartascredito_raw,
    fegusconfig.fe_ingestion_garantiasfacturascedidas_raw,
    fegusconfig.fe_ingestion_garantiasfiduciarias_raw,
    fegusconfig.fe_ingestion_garantiasmobiliarias_raw,
    fegusconfig.fe_ingestion_garantiaspolizas_raw,
    fegusconfig.fe_ingestion_garantiasreales_raw,
    fegusconfig.fe_ingestion_garantiasvalores_raw,
    fegusconfig.fe_ingestion_gravamenes_raw,
    fegusconfig.fe_ingestion_ingresodeudores_raw,
    fegusconfig.fe_ingestion_modificacion_raw,
    fegusconfig.fe_ingestion_naturalezagasto_raw,
    fegusconfig.fe_ingestion_operaciones_raw,
    fegusconfig.fe_ingestion_operacionesbienesrealizables_raw,
    fegusconfig.fe_ingestion_operacionescompradas_raw,
    fegusconfig.fe_ingestion_operacionesnoreportadas_raw,
    fegusconfig.fe_ingestion_origenrecursos_raw
RESTART IDENTITY CASCADE;

truncate table fegusconfig.fe_ingestion_sessions CASCADE;	

truncate table fegusconfig.fe_box_data_load CASCADE;	



COMMIT;