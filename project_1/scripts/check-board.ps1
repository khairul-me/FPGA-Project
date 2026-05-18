param(
    [string]$Port = ""
)

if (-not $Port) {
    $pnp = Get-CimInstance Win32_SerialPort | Where-Object { $_.PNPDeviceID -match 'VID_2E8A&PID_000A' }
    if ($pnp) {
        $Port = ($pnp | Select-Object -First 1).DeviceID
    } else {
        foreach ($c in [System.IO.Ports.SerialPort]::getportnames()) {
            $dev = Get-PnpDevice -Class Ports -ErrorAction SilentlyContinue |
                Where-Object { $_.FriendlyName -like "*$c*" -and $_.InstanceId -match 'VID_2E8A&PID_000A' }
            if ($dev) { $Port = $c; break }
        }
        if (-not $Port) { $Port = "COM7" }
    }
}

$ErrorActionPreference = "Continue"
Write-Host "Serial ports: $([System.IO.Ports.SerialPort]::getportnames() -join ', ')"
Write-Host "Probing $Port with mpremote..."

mpremote connect $Port exec "import sys; print('MicroPython', sys.version)" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Board not ready. If this is a new board, run:  scripts\flash.ps1"
    exit 1
}

mpremote connect $Port exec "from servo import servo2040; print('servo2040 OK, channels', servo2040.NUM_SERVOS)" 2>&1
