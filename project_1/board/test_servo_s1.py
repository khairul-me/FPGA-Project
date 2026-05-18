# Servo 2040 — SERVO 1 test (default ~2 min, visible min/max motion)

import time
import math
from servo import Servo, servo2040

SERVO_PIN = servo2040.SERVO_1
RUN_SECONDS = 120
SWEEP_DEG = 90.0
HOLD_SEC = 2.5

s = Servo(SERVO_PIN)
s.enable()
time.sleep(0.5)

print("Servo 1 ON — running for", RUN_SECONDS, "seconds")
print("Watch the horn: min -> max -> center, repeating")

start = time.ticks_ms()
cycle = 0
while time.ticks_diff(time.ticks_ms(), start) < RUN_SECONDS * 1000:
    cycle += 1
    elapsed = time.ticks_diff(time.ticks_ms(), start) // 1000
    print(cycle, "min", elapsed, "s")
    s.to_min()
    time.sleep(HOLD_SEC)
    s.to_max()
    time.sleep(HOLD_SEC)
    s.to_mid()
    time.sleep(1.0)

# Fill any leftover time with a slow sweep
while time.ticks_diff(time.ticks_ms(), start) < RUN_SECONDS * 1000:
    for i in range(360):
        if time.ticks_diff(time.ticks_ms(), start) >= RUN_SECONDS * 1000:
            break
        s.value(math.sin(math.radians(i)) * SWEEP_DEG)
        time.sleep(0.04)

s.to_mid()
time.sleep(0.3)
s.disable()
print("Done — ran", time.ticks_diff(time.ticks_ms(), start) // 1000, "s, servo disabled")
