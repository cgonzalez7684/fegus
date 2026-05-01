-- FUNCTION: feguscatalogos.fn_exportar_datamaster()

-- DROP FUNCTION IF EXISTS feguscatalogos.fn_exportar_datamaster();

CREATE OR REPLACE FUNCTION feguscatalogos.fn_exportar_datamaster()
    RETURNS jsonb
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE

AS $BODY$
DECLARE
    v_tabla   text;
    v_sql     text;
    v_filas   jsonb;
    v_result  jsonb := '{}'::jsonb;
BEGIN
    FOR v_tabla IN
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'feguscatalogos'
          AND table_type   = 'BASE TABLE'
        ORDER BY table_name
    LOOP
        v_sql := format(
            'SELECT COALESCE(jsonb_agg(to_jsonb(t)), ''[]''::jsonb)
             FROM (SELECT * FROM feguscatalogos.%I ORDER BY 1) t',
            v_tabla
        );
        EXECUTE v_sql INTO v_filas;
        v_result := v_result || jsonb_build_object(v_tabla, v_filas);
    END LOOP;

    RETURN v_result;
END;
$BODY$;

ALTER FUNCTION feguscatalogos.fn_exportar_datamaster()
    OWNER TO postgres;
