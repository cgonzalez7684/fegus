DO $$
DECLARE
    v_old_id_load_local    bigint := 598;  -- id_load que se usará en el WHERE
    v_new_id_load_local    bigint := -1;   -- nuevo valor para id_load_local

    v_table_name text;
    v_rows_updated bigint;
BEGIN
    FOREACH v_table_name IN ARRAY ARRAY[
        'actividadeconomica',
        'bienesrealizables',
        'bienesrealizablesnoreportados',
        'cambioclimatico',
        'codeudores',
        'creditossindicados',
        'cuentasporcobrarnosasociadas',
        'cuentasxcobrar',
        'cuotasatrasadas',
        'deudores',        
        'fideicomiso',
        'garantiascartascredito',
        'garantiasfacturascedidas',
        'garantiasfiduciarias',
        'garantiasmobiliarias',
        'garantiasoperacion',
        'garantiaspolizas',
        'garantiasreales',
        'garantiasvalores',
        'gravamenes',
        'ingresodeudores',
        'modificacion',
        'naturalezagasto',
        'operacionesbienesrealizables',
        'operacionescompradas',
        'operacionescredito',
        'operacionesnoreportadas',
        'origenrecursos'
    ]
    LOOP
        EXECUTE format(
            'UPDATE feguslocal.%I
             SET id_load_local = $1
             WHERE id_load_local = $2',
            v_table_name
        )
        USING v_new_id_load_local, v_old_id_load_local;

        GET DIAGNOSTICS v_rows_updated = ROW_COUNT;

        RAISE NOTICE 'Tabla feguslocal.% actualizada. Registros afectados: %',
            v_table_name,
            v_rows_updated;
    END LOOP;

	DELETE FROM feguslocal.fe_box_data_load WHERE id_load_local = v_old_id_load_local;

	GET DIAGNOSTICS v_rows_updated = ROW_COUNT;

	RAISE NOTICE 'Tabla feguslocal.fe_box_data_load borrar registro id_load_local. Registros afectados: %',		
		v_rows_updated;
	
END $$;