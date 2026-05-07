DO $$
DECLARE
    v_table record;
    v_count bigint;

    -- Cambiar aquí el valor del session_id que deseas consultar
    v_session_id uuid := '5d2beb3b-e390-4de6-b6d0-e5e8f286bc2a';
	v_id_load integer := 37;
BEGIN
    RAISE NOTICE 'Record count for _raw tables in schema fegusconfig';
    RAISE NOTICE 'Session ID: %', v_session_id;

    FOR v_table IN
        SELECT schemaname, tablename
        FROM pg_tables
        WHERE schemaname = 'fegusconfig'
          AND tablename LIKE '%\_raw' ESCAPE '\'
        ORDER BY tablename
    LOOP
        
		/*EXECUTE format(
            'SELECT COUNT(*) FROM %I.%I WHERE session_id = $1',
            v_table.schemaname,
            v_table.tablename
        )
        INTO v_count
        USING v_session_id;*/

		EXECUTE format(
            'SELECT COUNT(*) FROM %I.%I WHERE id_load = $1',
            v_table.schemaname,
            v_table.tablename
        )
        INTO v_count
        USING v_id_load;

        RAISE NOTICE '%.%: %', v_table.schemaname, v_table.tablename, v_count;
    END LOOP;
END $$;