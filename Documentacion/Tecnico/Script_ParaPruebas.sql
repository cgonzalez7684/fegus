

update fegusconfig.fe_box_data_load
set state_code = 'NEW',
    updated_at_utc = null,
	id_load_local = null
WHERE id_load = 2

update fegusconfig.fe_box_data_load
set state_code = 'NEW',
    updated_at_utc = null
WHERE id_load = 2


select * from feguslocal.fn_box_data_load_insert(
1001::integer,
2::bigint,
'CREATED'::TEXT,
'A'::TEXT,
null
)

select * from fegusconfig.fn_box_data_load_update(
1001::integer,
2::bigint,
563::bigint,
'CREATED'::TEXT,
'A'::TEXT
)

---------------PRUEBAS DE CARGA DE DATOS DEUDORES

---inicializar pruebas borras estas tablas, aplicar en feguslocal

update feguslocal.deudores
set id_load_local = -1;

update feguslocal.operacionescredito
set id_load_local = -1;

--aplicar en nube
DO $$
BEGIN
    DELETE FROM fegusconfig.fe_ingestion_deudores_raw;
    RAISE NOTICE 'DELETE fe_ingestion_deudores_raw completado';

    DELETE FROM fegusconfig.fe_ingestion_operaciones_raw;
    RAISE NOTICE 'DELETE fe_ingestion_operaciones_raw completado';

    DELETE FROM fegusconfig.fe_ingestion_sessions;
    RAISE NOTICE 'DELETE fe_ingestion_sessions completado';

    DELETE FROM fegusconfig.fe_box_data_load;
    RAISE NOTICE 'DELETE fe_box_data_load completado';
END $$;

update fegusconfig.fe_box_data_load
set state_code = 'RELOADING'
WHERE ID_LOAD = 28;

--fin inicializar

select * from fegusconfig.fe_box_state

--insert un nuevo bloque, inicia todo el flujo ya que FegusDAgent se da cuenta de
--este nuevo registro de estado NEW y desencadena el flujo de carga.
select * from fegusconfig.fn_box_data_load_insert(
1001::integer,
'NEW'::TEXT,
'A'::TEXT,
TO_DATE('12/04/2026', 'DD/MM/YYYY')::timestamp 
)

select * from fegusconfig.fe_box_data_load



select * from feguslocal.fe_box_data_load

select * from feguslocal.deudores


select * from feguslocal.operacionescredito

select count(1) from feguslocal.deudores
--60000

select count(1) from feguslocal.operacionescredito
--180434

select count(1) from feguslocal.operacionescredito

select * from fegusconfig.fe_ingestion_sessions	
order by created_at_utc desc

select * from fegusconfig.fe_ingestion_deudores_raw
where sessio

select * from fegusconfig.fe_ingestion_deudores_raw

select count(1) from fegusconfig.fe_ingestion_deudores_raw

select * from fegusconfig.fe_ingestion_operaciones_raw

select count(1) from fegusconfig.fe_ingestion_operaciones_raw

select count(1) from fegusconfig.fe_ingestion_deudores_raw

select * from fegusconfig.fe_ingestion_deudores_raw

select * from fegusconfig.fe_ingestion_operaciones_raw

-------------------------------------------------------------

update fegusconfig.fe_ingestion_sessions	
set last_sequence = 25
where session_id = 'd9d99650-e3fa-4e2e-8ba9-b88ab19bb75a'

select * from fegusconfig.fe_session_state

INSERT INTO fegusconfig.fe_session_state
VALUES('CREATED','CREATED','true','false','false','A')

INSERT INTO fegusconfig.fe_session_state
VALUES('RECEIVING','RECEIVING','false','false','false','A')

INSERT INTO fegusconfig.fe_session_state
VALUES('COMPLETED','COMPLETED','false','true','false','A')

INSERT INTO fegusconfig.fe_session_state
VALUES('FAILED','FAILED','false','true','true','A')

select * from fegusseg.customers

select * from fegusconfig.fe_box_data_load_status_detail

delete from fegusconfig.fe_box_data_load

select * from fegusconfig.fn_box_data_load_get(1001)

select * from fegusconfig.fn_next_box_data_load_get(1001)

select * from feguslocal.fe_box_data_load b
 WHERE b.id_cliente = 1001
      AND b.state_code = 'CREATED'
    ORDER BY b.created_at_utc ASC



select * from feguslocal.deudores

select * from feguslocal.operacionescredito

select count(1) from feguslocal.operacionescredito

select count(1) from feguslocal.deudores
where id_load_local = 568

select * from feguslocal.obtener_deudores_lista(568)

