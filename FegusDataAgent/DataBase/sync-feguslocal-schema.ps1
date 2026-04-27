# =============================
# CONFIGURACION
# =============================
$DB_NAME = "FegusApp"
$DB_USER = "postgres"
$DB_HOST = "localhost"
$DB_PORT = "5432"
$SCHEMA  = "feguslocal"

$BASE_PATH = "C:\Software\Fegus\FegusDataAgent\DataBase\Schemas\feguslocal"

# Password (opcional)
$env:PGPASSWORD = "tu_password"

# =============================
# FUNCION: Ejecutar query
# =============================
function Get-DbObjects($query) {
    $result = & psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -c $query
    return $result | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
}

# =============================
# FUNCION: Exportar objeto
# =============================
function Export-Object($name, $folder, $pgDumpArgs) {
    try {
        $filePath = Join-Path $folder "$name.sql"

        Write-Host "  -> $name"

        & pg_dump @pgDumpArgs "--file=$filePath" | Out-Null
    }
    catch {
        Write-Host "ERROR exportando $name : $_" -ForegroundColor Red
    }
}

# =============================
# LIMPIAR ARCHIVOS ANTIGUOS
# =============================
Write-Host "Limpiando archivos existentes..." -ForegroundColor Yellow

Get-ChildItem -Path $BASE_PATH -Recurse -Filter *.sql | Remove-Item -Force

# =============================
# TABLES
# =============================
Write-Host "`nExportando TABLES..." -ForegroundColor Cyan

$tables = Get-DbObjects "SELECT table_name FROM information_schema.tables WHERE table_schema='$SCHEMA' AND table_type='BASE TABLE';"

foreach ($t in $tables) {
    Export-Object $t "$BASE_PATH\Tables" @(
        "-h",$DB_HOST,"-p",$DB_PORT,"-U",$DB_USER,"-d",$DB_NAME,
        "-t","$SCHEMA.$t",
        "--schema-only"
    )
}

# =============================
# FUNCTIONS
# =============================
Write-Host "`nExportando FUNCTIONS..." -ForegroundColor Cyan

$functions = Get-DbObjects "SELECT routine_name FROM information_schema.routines WHERE routine_schema='$SCHEMA' AND routine_type='FUNCTION';"

foreach ($f in $functions) {
    Export-Object $f "$BASE_PATH\Functions" @(
        "-h",$DB_HOST,"-p",$DB_PORT,"-U",$DB_USER,"-d",$DB_NAME,
        "-n",$SCHEMA,
        "--schema-only"
    )
}

# =============================
# PROCEDURES
# =============================
Write-Host "`nExportando PROCEDURES..." -ForegroundColor Cyan

$procedures = Get-DbObjects "SELECT routine_name FROM information_schema.routines WHERE routine_schema='$SCHEMA' AND routine_type='PROCEDURE';"

foreach ($p in $procedures) {
    Export-Object $p "$BASE_PATH\Procedures" @(
        "-h",$DB_HOST,"-p",$DB_PORT,"-U",$DB_USER,"-d",$DB_NAME,
        "-n",$SCHEMA,
        "--schema-only"
    )
}

# =============================
# SEQUENCES
# =============================
Write-Host "`nExportando SEQUENCES..." -ForegroundColor Cyan

$sequences = Get-DbObjects "SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema='$SCHEMA';"

foreach ($s in $sequences) {
    Export-Object $s "$BASE_PATH\Sequences" @(
        "-h",$DB_HOST,"-p",$DB_PORT,"-U",$DB_USER,"-d",$DB_NAME,
        "-t","$SCHEMA.$s",
        "--schema-only"
    )
}

# =============================
# TYPES
# =============================
Write-Host "`nExportando TYPES..." -ForegroundColor Cyan

$types = Get-DbObjects "SELECT typname FROM pg_type t JOIN pg_namespace n ON n.oid = t.typnamespace WHERE n.nspname='$SCHEMA' AND t.typtype='c';"

foreach ($t in $types) {
    Export-Object $t "$BASE_PATH\Types" @(
        "-h",$DB_HOST,"-p",$DB_PORT,"-U",$DB_USER,"-d",$DB_NAME,
        "-n",$SCHEMA,
        "--schema-only"
    )
}

# =============================
# GIT (OPCIONAL)
# =============================
Write-Host "`nHaciendo commit en Git..." -ForegroundColor Green

Set-Location "C:\Software\Fegus\FegusDataAgent"

git add .

$changes = git status --porcelain
if ($changes) {
    git commit -m "Auto-sync schema feguslocal"
    Write-Host "Commit realizado."
} else {
    Write-Host "No hay cambios."
}

Write-Host "`nProceso finalizado correctamente." -ForegroundColor Green