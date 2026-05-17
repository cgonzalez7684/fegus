-- Target: ConnectionStringAzure (Azure PostgreSQL)
-- Coordinator: calls all 28 per-dataset load functions for a given box.
-- Called by the BackEnd BoxLoadingHostedService during LOADING state.
-- Returns one row per dataset with (dataset, pqty, psqlcode, psqlmessage).

CREATE OR REPLACE FUNCTION fegusdata.fn_load_all_datasets_from_raw(
    p_id_cliente integer,
    p_id_load    bigint
)
RETURNS TABLE(dataset text, pqty integer, psqlcode text, psqlmessage text)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY SELECT 'deudores'::text,                   f.* FROM fegusdata.fn_load_deudores_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'operacionescredito'::text,         f.* FROM fegusdata.fn_load_operacionescredito_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'actividadeconomica'::text,         f.* FROM fegusdata.fn_load_actividadeconomica_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'bienesrealizables'::text,          f.* FROM fegusdata.fn_load_bienesrealizables_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'bienesrealizablesnoreportados'::text, f.* FROM fegusdata.fn_load_bienesrealizablesnoreportados_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'cambioclimatico'::text,            f.* FROM fegusdata.fn_load_cambioclimatico_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'codeudores'::text,                 f.* FROM fegusdata.fn_load_codeudores_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'creditossindicados'::text,         f.* FROM fegusdata.fn_load_creditossindicados_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'cuentasxcobrar'::text,             f.* FROM fegusdata.fn_load_cuentasxcobrar_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'cuentasporcobrarnosasociadas'::text, f.* FROM fegusdata.fn_load_cuentasporcobrarnosasociadas_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'cuotasatrasadas'::text,            f.* FROM fegusdata.fn_load_cuotasatrasadas_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'fideicomiso'::text,                f.* FROM fegusdata.fn_load_fideicomiso_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'garantiasoperacion'::text,         f.* FROM fegusdata.fn_load_garantiasoperacion_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'garantiascartascredito'::text,     f.* FROM fegusdata.fn_load_garantiascartascredito_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'garantiasfacturascedidas'::text,   f.* FROM fegusdata.fn_load_garantiasfacturascedidas_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'garantiasfiduciarias'::text,       f.* FROM fegusdata.fn_load_garantiasfiduciarias_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'garantiasmobiliarias'::text,       f.* FROM fegusdata.fn_load_garantiasmobiliarias_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'garantiaspolizas'::text,           f.* FROM fegusdata.fn_load_garantiaspolizas_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'garantiasreales'::text,            f.* FROM fegusdata.fn_load_garantiasreales_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'garantiasvalores'::text,           f.* FROM fegusdata.fn_load_garantiasvalores_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'gravamenes'::text,                 f.* FROM fegusdata.fn_load_gravamenes_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'ingresodeudores'::text,            f.* FROM fegusdata.fn_load_ingresodeudores_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'modificacion'::text,               f.* FROM fegusdata.fn_load_modificacion_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'naturalezagasto'::text,            f.* FROM fegusdata.fn_load_naturalezagasto_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'operacionesbienesrealizables'::text, f.* FROM fegusdata.fn_load_operacionesbienesrealizables_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'operacionescompradas'::text,       f.* FROM fegusdata.fn_load_operacionescompradas_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'operacionesnoreportadas'::text,    f.* FROM fegusdata.fn_load_operacionesnoreportadas_from_raw(p_id_cliente, p_id_load) f;
    RETURN QUERY SELECT 'origenrecursos'::text,             f.* FROM fegusdata.fn_load_origenrecursos_from_raw(p_id_cliente, p_id_load) f;
END;
$$;
