# Pimoroni / Pico USB reset: open serial at 1200 baud to enter BOOTSEL (RPI-RP2)
param([string]$Port = "COM6")

python -c @"
import serial, sys
port = sys.argv[1]
try:
    s = serial.Serial(port, 1200, timeout=1)
    s.close()
except Exception as e:
    # Port may vanish as the board reboots — that is OK
    print('Note:', e)
print('If successful, RPI-RP2 will appear in a few seconds.')
"@ $Port
