DO $$
DECLARE
    v_table record;
    v_count bigint;
BEGIN
    RAISE NOTICE 'Record count for tables in schema feguslocal';

    FOR v_table IN
        SELECT schemaname, tablename
        FROM pg_tables
        WHERE schemaname = 'feguslocal'
        ORDER BY tablename
    LOOP
        EXECUTE format('SELECT COUNT(*) FROM %I.%I', v_table.schemaname, v_table.tablename)
        INTO v_count;

        RAISE NOTICE '%.%: %', v_table.schemaname, v_table.tablename, v_count;
    END LOOP;
END $$;
