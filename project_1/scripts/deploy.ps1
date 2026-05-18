param(
    [string]$Port = ""
)

$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent

& (Join-Path $PSScriptRoot "check-board.ps1") -Port $Port
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Copying main.py..."
mpremote connect $Port fs cp "$Root\board\main.py" :main.py

Write-Host "Ready. After wiring servo to SERVO 1, run:"
Write-Host "  mpremote connect $Port run `"$Root\board\test_servo_s1.py`""
