-- Target: ConnectionStringAzure (Azure PostgreSQL)
-- Inserts the LOADING box state and its valid transitions into the state machine.
-- Run once per environment after deploying the fn_load_all_datasets_from_raw function.

-- LOADING state
INSERT INTO fegusconfig.fe_box_state (state_code, state_name, is_initial, is_final, is_error_state, is_active, created_at_utc)
VALUES ('LOADING', 'Cargando datos a fegusdata', false, false, false, 'A', NOW())
ON CONFLICT (state_code) DO NOTHING;

-- Valid transitions
INSERT INTO fegusconfig.fe_box_state_transition (from_state, to_state, transition_name, is_active)
VALUES
    ('STAGING',  'LOADING',    'begin_loading',    'A'),
    ('LOADING',  'VALIDATING', 'loading_complete',  'A'),
    ('LOADING',  'ERROR',      'loading_failed',    'A')
ON CONFLICT (from_state, to_state) DO NOTHING;
