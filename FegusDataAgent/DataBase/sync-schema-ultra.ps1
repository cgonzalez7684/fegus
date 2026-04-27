# =============================
# CONFIG
# =============================
$DB_NAME = "FegusApp"
$DB_USER = "postgres"
$DB_HOST = "localhost"
$DB_PORT = "5433"
$SCHEMA  = "feguslocal"

$BASE_PATH = "C:\Software\Fegus\FegusDataAgent\DataBase\Schemas\feguslocal"
$TEMP_FILE = "$env:TEMP\fegus_schema_dump.sql"

$env:PGPASSWORD = "Car7684$"

Write-Host "==== GENERANDO DUMP COMPLETO ====" -ForegroundColor Cyan

# =============================
# STEP 1: Dump completo del schema
# =============================
pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -n $SCHEMA --schema-only --no-owner --no-privileges > $TEMP_FILE

if (!(Test-Path $TEMP_FILE)) {
    Write-Host "ERROR: No se pudo generar dump" -ForegroundColor Red
    exit
}

$content = Get-Content $TEMP_FILE -Raw

# =============================
# STEP 2: Limpiar carpetas
# =============================
Write-Host "Limpiando carpetas..." -ForegroundColor Yellow

Get-ChildItem "$BASE_PATH\Tables" -Filter *.sql -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem "$BASE_PATH\Functions" -Filter *.sql -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem "$BASE_PATH\Procedures" -Filter *.sql -ErrorAction SilentlyContinue | Remove-Item -Force
Get-ChildItem "$BASE_PATH\Sequences" -Filter *.sql -ErrorAction SilentlyContinue | Remove-Item -Force

# =============================
# STEP 3: Regex patterns
# =============================
$patterns = @{
    Tables     = "(?ms)(CREATE TABLE .*?;)"
    Functions  = "(?ms)(CREATE FUNCTION .*?;)"
    Procedures = "(?ms)(CREATE PROCEDURE .*?;)"
    Sequences  = "(?ms)(CREATE SEQUENCE .*?;)"
}

# =============================
# STEP 4: Split por tipo
# =============================
foreach ($type in $patterns.Keys) {

    Write-Host "`nProcesando $type..." -ForegroundColor Cyan

    $matches = [regex]::Matches($content, $patterns[$type])

    foreach ($m in $matches) {

        $sql = $m.Value

        # Obtener nombre del objeto
        if ($type -eq "Tables") {
            $name = ($sql -match "CREATE TABLE\s+([^\s(]+)") | Out-Null
            $name = $Matches[1].Split(".")[-1]
        }
        elseif ($type -eq "Functions") {
            $name = ($sql -match "CREATE FUNCTION\s+([^\s(]+)") | Out-Null
            $name = $Matches[1].Split(".")[-1]
        }
        elseif ($type -eq "Procedures") {
            $name = ($sql -match "CREATE PROCEDURE\s+([^\s(]+)") | Out-Null
            $name = $Matches[1].Split(".")[-1]
        }
        elseif ($type -eq "Sequences") {
            $name = ($sql -match "CREATE SEQUENCE\s+([^\s;]+)") | Out-Null
            $name = $Matches[1].Split(".")[-1]
        }

        if (![string]::IsNullOrWhiteSpace($name)) {

            $filePath = Join-Path "$BASE_PATH\$type" "$name.sql"

            $sql | Out-File -Encoding UTF8 $filePath

            Write-Host "  -> $name"
        }
    }
}

# =============================
# STEP 5: Git auto
# =============================
Write-Host "`nSincronizando con Git..." -ForegroundColor Green

Set-Location "C:\Software\Fegus\FegusDataAgent"

git add .

$changes = git status --porcelain

if ($changes) {
    git commit -m "Ultra-sync schema $SCHEMA"
    Write-Host "Commit realizado."
} else {
    Write-Host "No hay cambios."
}

Write-Host "`n==== COMPLETADO ====" -ForegroundColor Green