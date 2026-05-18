# Servo not moving?

## Your board: servo power rail is ~0.06 V (no power)

A live reading from your Servo 2040 showed **~0.06 V** on the servo supply (expect **4.5–6 V**).  
PWM and RGB LEDs work, but **the servo + pin has almost no voltage**, so the motor cannot run.

**Fix:** connect a **5–6 V** supply (battery pack, bench supply, or 5 V 2 A+ adapter) to the **EXT** screw terminals on the board:

| Terminal | Wire |
|----------|------|
| **+** | Supply **+** (5–6 V) |
| **−** | Supply **−** (GND) |

Keep **USB-C** plugged in for programming. **Common ground** between supply and board is required (the EXT − terminal is that ground).

After wiring EXT, run:

```powershell
mpremote connect COM7 run board\power_check.py
```

You should see **≥ 4 V**. Then run `board\diagnose_servo.py` again.

If EXT is already connected but voltage stays low, inspect the **“Separate USB and Ext. Power”** trace on the **back** of the board (Pimoroni docs) — if it is cut, USB will not feed the servo rail and EXT is mandatory.

---

Software on your PC **is** driving the board (PWM on GPIO 0 for SERVO 1). If the horn stays still with good rail voltage, check mechanical wiring below.

## Correct header (most common mistake)

| Wrong | Right |
|-------|--------|
| **SENSORS 1–6** on the **top** edge (horizontal row) | **SERVO 1** on the **left** edge (vertical column) |
| First header = **SERVO 1** (top of the 1–18 list) | |

Silkscreen on each 3-pin servo header (top → bottom):

1. **~** (square wave) = **signal** → orange / yellow / white on servo
2. **+** = **power** → red
3. **−** = **ground** → brown / black

## Power

- **USB only**: OK for a **small** servo (e.g. SG90) with **no load** on the horn.
- **Heavier servo or any load**: use **EXT** screw terminals — **5–6 V**, enough amps (1 A+), **GND tied to board ground**.
- If you cut the “Separate USB and Ext. Power” trace on the back, the servo rail may **not** be fed from USB at all — use EXT or restore that jumper/trace.

## Quick checks

1. Run diagnose (blinks **RGB LEDs** then moves servo):
   ```powershell
   mpremote connect COM7 run board\diagnose_servo.py
   ```
   - **LEDs blink, servo still still** → re-seat wires on **SERVO 1**, check **+** has voltage (multimeter on red vs GND).
   - **Nothing at all** → wrong COM port or USB cable (charge-only).

2. Try another **SERVO 2** header and change script to `servo2040.SERVO_2`.

3. Test the servo on a known-good controller if you have one (dead servos happen).
