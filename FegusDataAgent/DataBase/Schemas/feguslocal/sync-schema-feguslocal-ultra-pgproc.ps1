# ==========================================
# CONFIGURACION
# ==========================================
$DB_NAME = "FegusApp"
$DB_USER = "postgres"
$DB_HOST = "localhost"
$DB_PORT = "5433"
$SCHEMA  = "feguslocal"

$BASE_PATH = "C:\Software\Fegus\FegusDataAgent\DataBase\Schemas\feguslocal"
$TEMP_FILE = "$env:TEMP\fegus_feguslocal_tmp.sql"

$env:PGPASSWORD = "Car7684$"

# Detectar pgFormatter
$PGFORMAT = Get-Command pg_format -ErrorAction SilentlyContinue

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "SYNC ULTRA PRO FINAL ($SCHEMA)" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# ==========================================
# FUNCION EJECUTAR SQL
# ==========================================
function Exec-Sql($query) {
    return & psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -t -A -c $query
}

# ==========================================
# FORMATEO SQL (Fallback)
# ==========================================
function Format-Sql($sql) {
    $sql = $sql -replace "\r\n", "`n"
    $sql = $sql -replace "\bAS\s+\$\$", "`nAS `$\$`n"
    $sql = $sql -replace "\$\$\s+LANGUAGE", "`n`$\$ LANGUAGE"
    $sql = $sql -replace "\bBEGIN\b", "`nBEGIN"
    $sql = $sql -replace "\bEND;\b", "`nEND;"
    $sql = $sql -replace "\bDECLARE\b", "`nDECLARE"
    $sql = $sql -replace "`n{2,}", "`n"
    return $sql.Trim()
}

# ==========================================
# FUNCION GUARDAR SQL (con formato)
# ==========================================
function Save-Sql($sql, $filePath) {

    if ($PGFORMAT) {
        $tempIn = "$env:TEMP\in.sql"
        $tempOut = "$env:TEMP\out.sql"

        $sql | Out-File -Encoding UTF8 $tempIn
        & pg_format $tempIn > $tempOut

        Get-Content $tempOut | Out-File -Encoding UTF8 $filePath

        Remove-Item $tempIn,$tempOut -ErrorAction SilentlyContinue
    }
    else {
        $formatted = Format-Sql $sql
        $formatted | Out-File -Encoding UTF8 $filePath
    }
}

# ==========================================
# PREPARAR CARPETAS
# ==========================================
$folders = @("Tables","Functions","Procedures","Sequences")

foreach ($f in $folders) {
    $path = Join-Path $BASE_PATH $f
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }
    Get-ChildItem $path -Filter *.sql -ErrorAction SilentlyContinue | Remove-Item -Force
}

# ==========================================
# TABLES
# ==========================================
Write-Host "`nExportando TABLES..." -ForegroundColor Yellow

$tables = Exec-Sql "SELECT tablename FROM pg_tables WHERE schemaname='$SCHEMA';"

foreach ($t in $tables) {
    $t = $t.Trim()
    if ($t -ne "") {

        Write-Host "  -> $t"

        pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME `
            -t "$SCHEMA.$t" --schema-only `
            > $TEMP_FILE

        $sql = Get-Content $TEMP_FILE -Raw
        Save-Sql $sql "$BASE_PATH\Tables\$t.sql"
    }
}

# ==========================================
# FUNCTIONS (pg_proc)
# ==========================================
Write-Host "`nExportando FUNCTIONS..." -ForegroundColor Yellow

$functions = Exec-Sql @"
SELECT p.oid,
       p.proname,
       pg_get_function_identity_arguments(p.oid)
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = '$SCHEMA'
AND p.prokind = 'f';
"@

foreach ($line in $functions) {

    if ($line -ne "") {

        $parts = $line.Split("|")
        $oid = $parts[0]
        $name = $parts[1]
        $args = $parts[2]

        $safeName = ($name + "_" + ($args -replace '[^a-zA-Z0-9]', '_'))

        Write-Host "  -> $name($args)"

        $sql = Exec-Sql "SELECT pg_get_functiondef($oid);"

        $drop = "DROP FUNCTION IF EXISTS $SCHEMA.$name($args) CASCADE;`n"
        Save-Sql ($drop + $sql) "$BASE_PATH\Functions\$safeName.sql"
    }
}

# ==========================================
# PROCEDURES
# ==========================================
Write-Host "`nExportando PROCEDURES..." -ForegroundColor Yellow

$procedures = Exec-Sql @"
SELECT p.oid,
       p.proname,
       pg_get_function_identity_arguments(p.oid)
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = '$SCHEMA'
AND p.prokind = 'p';
"@

foreach ($line in $procedures) {

    if ($line -ne "") {

        $parts = $line.Split("|")
        $oid = $parts[0]
        $name = $parts[1]
        $args = $parts[2]

        $safeName = ($name + "_" + ($args -replace '[^a-zA-Z0-9]', '_'))

        Write-Host "  -> $name($args)"

        $sql = Exec-Sql "SELECT pg_get_functiondef($oid);"

        $drop = "DROP PROCEDURE IF EXISTS $SCHEMA.$name($args) CASCADE;`n"
        Save-Sql ($drop + $sql) "$BASE_PATH\Procedures\$safeName.sql"
    }
}

# ==========================================
# SEQUENCES
# ==========================================
Write-Host "`nExportando SEQUENCES..." -ForegroundColor Yellow

$sequences = Exec-Sql "SELECT sequence_name FROM information_schema.sequences WHERE sequence_schema='$SCHEMA';"

foreach ($s in $sequences) {
    $s = $s.Trim()
    if ($s -ne "") {

        Write-Host "  -> $s"

        pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME `
            -t "$SCHEMA.$s" --schema-only `
            > $TEMP_FILE

        $sql = Get-Content $TEMP_FILE -Raw
        Save-Sql $sql "$BASE_PATH\Sequences\$s.sql"
    }
}

# ==========================================
# GIT AUTO
# ==========================================
<#Write-Host "`nSincronizando con Git..." -ForegroundColor Green

Set-Location "C:\Software\Fegus\FegusDataAgent"

git add .

$changes = git status --porcelain

if ($changes) {
    git commit -m "Ultra-sync schema $SCHEMA"
    Write-Host "Commit realizado." -ForegroundColor Green
} else {
    Write-Host "No hay cambios." -ForegroundColor Yellow
}#>

Write-Host "`n=====================================" -ForegroundColor Cyan
Write-Host "SYNC COMPLETADO (ULTRA FINAL)" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan