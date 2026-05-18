# Hardware check: LEDs blink, then SERVO 1 holds min/max 20s each.
# If LEDs blink but servo does not move -> wiring or power, not code.

import time
from plasma import WS2812
from servo import Servo, servo2040

print("=== Servo 2040 diagnose ===")
print("SERVO 1 = left edge, TOP 3-pin header (not top SENSOR row)")

# 1) RGB LEDs — you should see red/green/blue chase on the board
led = WS2812(servo2040.NUM_LEDS, 0, 0, servo2040.LED_DATA)
print("LED chase 6s — look at the 6 LEDs on the board")
for _ in range(6):
    for c in [(40, 0, 0), (0, 40, 0), (0, 0, 40)]:
        for n in range(servo2040.NUM_LEDS):
            led.set_rgb(n, c[0], c[1], c[2])
        led.update()
        time.sleep(0.35)

# 2) Servo — hold extremes slowly
s = Servo(servo2040.SERVO_1)
print("GPIO pin:", s.pin())
s.enable()

print("MIN position 20s — horn should move and stay")
s.to_min()
time.sleep(20)

print("MAX position 20s — horn should move the other way")
s.to_max()
time.sleep(20)

s.to_mid()
time.sleep(1)
s.disable()
print("=== done ===")
