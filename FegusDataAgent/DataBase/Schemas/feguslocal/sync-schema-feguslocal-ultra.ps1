# ==========================================
# CONFIGURACION
# ==========================================
$DB_NAME = "FegusApp"
$DB_USER = "postgres"
$DB_HOST = "localhost"
$DB_PORT = "5433"
$SCHEMA  = "feguslocal"

$BASE_PATH = "C:\Software\Fegus\FegusDataAgent\DataBase\Schemas\feguslocal"
$TEMP_FILE = "$env:TEMP\fegus_schema_feguslocal_dump.sql"

# Password (opcional)
$env:PGPASSWORD = "Car7684$"

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "SYNC ULTRA PRO SCHEMA: $SCHEMA" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan

# ==========================================
# VALIDACION DE CARPETAS
# ==========================================
$folders = @("Tables","Functions","Procedures","Sequences","Types")

foreach ($f in $folders) {
    $path = Join-Path $BASE_PATH $f
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
    }
}

# ==========================================
# STEP 1: DUMP COMPLETO
# ==========================================
Write-Host "`nGenerando dump del schema..." -ForegroundColor Yellow

pg_dump -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME `
    -n $SCHEMA --schema-only --no-owner --no-privileges > $TEMP_FILE

if (!(Test-Path $TEMP_FILE)) {
    Write-Host "ERROR: No se pudo generar dump" -ForegroundColor Red
    exit
}

$content = Get-Content $TEMP_FILE -Raw

# ==========================================
# STEP 2: LIMPIAR ARCHIVOS
# ==========================================
Write-Host "Limpiando archivos existentes..." -ForegroundColor Yellow

foreach ($f in $folders) {
    Get-ChildItem "$BASE_PATH\$f" -Filter *.sql -ErrorAction SilentlyContinue | Remove-Item -Force
}

# ==========================================
# STEP 3: REGEX ROBUSTO
# ==========================================
$patterns = @{
    Tables     = "(?ms)(CREATE TABLE .*?;)"
    Sequences  = "(?ms)(CREATE SEQUENCE .*?;)"

    Functions  = "(?ms)(CREATE\s+(OR\s+REPLACE\s+)?FUNCTION.*?\$[^\$]*\$.*?\$[^\$]*\$\s+LANGUAGE\s+\w+.*?;)"
    Procedures = "(?ms)(CREATE\s+(OR\s+REPLACE\s+)?PROCEDURE.*?\$[^\$]*\$.*?\$[^\$]*\$\s+LANGUAGE\s+\w+.*?;)"
}

# ==========================================
# FUNCION PARA LIMPIAR NOMBRES
# ==========================================
function Clean-Name($name) {
    return ($name -replace '[^a-zA-Z0-9_]', '_')
}

# ==========================================
# FUNCION EXPORTAR
# ==========================================
function Export-Objects($type, $regexPattern) {

    Write-Host "`nProcesando $type..." -ForegroundColor Cyan

    $matches = [regex]::Matches($content, $regexPattern)

    foreach ($m in $matches) {

        $sql = $m.Value

        try {
            switch ($type) {
                "Tables" {
                    $sql -match "CREATE TABLE\s+([^\s(]+)" | Out-Null
                }
                "Functions" {
                    $sql -match "CREATE\s+(OR\s+REPLACE\s+)?FUNCTION\s+([^\s(]+)" | Out-Null
                }
                "Procedures" {
                    $sql -match "CREATE\s+(OR\s+REPLACE\s+)?PROCEDURE\s+([^\s(]+)" | Out-Null
                }
                "Sequences" {
                    $sql -match "CREATE SEQUENCE\s+([^\s;]+)" | Out-Null
                }
            }

            if ($type -eq "Functions" -or $type -eq "Procedures") {
                $name = $Matches[2]
            } else {
                $name = $Matches[1]
            }

            $name = $name.Split(".")[-1]
            $name = Clean-Name $name

            if (![string]::IsNullOrWhiteSpace($name)) {

                # DROP opcional (PRO TIP)
                if ($type -eq "Functions") {
                    $sql = "DROP FUNCTION IF EXISTS $SCHEMA.$name CASCADE;`n" + $sql
                }
                elseif ($type -eq "Procedures") {
                    $sql = "DROP PROCEDURE IF EXISTS $SCHEMA.$name CASCADE;`n" + $sql
                }

                $filePath = Join-Path "$BASE_PATH\$type" "$name.sql"

                $sql | Out-File -Encoding UTF8 $filePath

                if ($sql.Length -lt 80) {
                    Write-Host "WARNING posible corte en $name" -ForegroundColor Yellow
                }

                Write-Host "  -> $name"
            }
        }
        catch {
            Write-Host "ERROR procesando objeto: $_" -ForegroundColor Red
        }
    }
}

# ==========================================
# STEP 4: EXPORTACION
# ==========================================
Export-Objects "Tables"     $patterns.Tables
Export-Objects "Functions"  $patterns.Functions
Export-Objects "Procedures" $patterns.Procedures
Export-Objects "Sequences"  $patterns.Sequences

# ==========================================
# STEP 5: GIT AUTO
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
Write-Host "SYNC COMPLETADO" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan