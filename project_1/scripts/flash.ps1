# Copy Pimoroni MicroPython UF2 to Servo 2040 when it appears as RPI-RP2
$ErrorActionPreference = "Stop"
$Root = Split-Path $PSScriptRoot -Parent
$Uf2 = Join-Path $Root "firmware\pico-v1.27.0-pimoroni-micropython.uf2"

if (-not (Test-Path $Uf2)) {
    throw "Missing firmware: $Uf2"
}

Write-Host "Trying USB bootloader reset (1200 baud)..."
& (Join-Path $PSScriptRoot "enter-bootloader.ps1") -Port COM6 2>$null
& (Join-Path $PSScriptRoot "enter-bootloader.ps1") -Port COM7 2>$null
Start-Sleep -Seconds 2
Write-Host "If that fails: hold BOOT/USER, tap RESET, release BOOT."
Write-Host "Waiting up to 120s for RPI-RP2 drive..."

$deadline = (Get-Date).AddSeconds(120)
$drive = $null
while ((Get-Date) -lt $deadline) {
    $vol = Get-Volume -ErrorAction SilentlyContinue |
        Where-Object { $_.FileSystemLabel -eq "RPI-RP2" -and $_.DriveLetter }
    if ($vol) {
        $drive = "{0}:" -f $vol.DriveLetter
        break
    }
    Start-Sleep -Seconds 1
}

if (-not $drive) {
    throw "RPI-RP2 not found. Check USB cable and BOOTSEL steps."
}

Write-Host "Flashing to $drive"
Copy-Item -Path $Uf2 -Destination (Join-Path $drive "firmware.uf2") -Force
Write-Host "UF2 copied — board will reboot. Wait ~5s, then run scripts\check-board.ps1"
