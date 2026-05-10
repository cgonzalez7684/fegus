-- Migration: add seq column (GENERATED ALWAYS AS IDENTITY) to all 28 feguslocal entity tables.
-- Target: ConnectionStringLocal  (Host=localhost;Port=5433;Database=FegusApp;...)
--
-- This column is the stable source-side sequence used for resume-on-failure.
-- feguslocal holds staging data; truncate+reload is acceptable on existing instances.
-- Existing rows will have seq = NULL after ALTER TABLE; run a backfill or truncate+reload.

DO $$
DECLARE
    v_tables text[] := ARRAY[
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
    ];
    v_table text;
BEGIN
    FOREACH v_table IN ARRAY v_tables
    LOOP
        -- Add seq column if it does not exist yet
        IF NOT EXISTS (
            SELECT 1
            FROM information_schema.columns
            WHERE table_schema = 'feguslocal'
              AND table_name   = v_table
              AND column_name  = 'seq'
        ) THEN
            EXECUTE format(
                'ALTER TABLE feguslocal.%I ADD COLUMN seq bigint GENERATED ALWAYS AS IDENTITY (START 1 INCREMENT 1)',
                v_table
            );
            RAISE NOTICE 'Added seq column to feguslocal.%', v_table;
        ELSE
            RAISE NOTICE 'seq column already exists in feguslocal.%, skipping', v_table;
        END IF;
    END LOOP;
END;
$$;

-- After running this script, existing rows will have seq = NULL.
-- Since feguslocal is a staging database, the recommended approach is:
--   TRUNCATE feguslocal.<table>;
-- and reload data through the normal ingestion process.
-- New inserts will automatically receive a monotonically increasing seq value.
