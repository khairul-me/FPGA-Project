param([string]$Port = "")
$Root = Split-Path $PSScriptRoot -Parent
if (-not $Port) {
    & (Join-Path $PSScriptRoot "check-board.ps1") | Out-Null
    $pnp = Get-CimInstance Win32_SerialPort | Where-Object { $_.PNPDeviceID -match 'VID_2E8A&PID_000A' }
    $Port = if ($pnp) { $pnp.DeviceID } else { "COM7" }
}
mpremote connect $Port run "$Root\board\test_servo_s1.py"
