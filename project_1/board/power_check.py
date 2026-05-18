# Servo rail power check — run before any servo test

from servo import servo2040
from pimoroni import Analog, AnalogMux

mux = AnalogMux(servo2040.ADC_ADDR_0, servo2040.ADC_ADDR_1, servo2040.ADC_ADDR_2)
vol = Analog(servo2040.SHARED_ADC, servo2040.VOLTAGE_GAIN)
cur = Analog(servo2040.SHARED_ADC, servo2040.CURRENT_GAIN, servo2040.SHUNT_RESISTOR, servo2040.CURRENT_OFFSET)

mux.select(servo2040.VOLTAGE_SENSE_ADDR)
v = vol.read_voltage()
mux.select(servo2040.CURRENT_SENSE_ADDR)
a = cur.read_current()

print("Servo rail voltage: {:.2f} V".format(v))
print("Servo rail current:   {:.3f} A".format(a))

if v < 4.0:
    print("")
    print("NO SERVO POWER — signal is working but the 5V rail is dead.")
    print("Connect a 5-6 V supply to the EXT screw terminals (+ and -).")
    print("Keep USB plugged in for programming. Tie grounds together.")
    print("If EXT is already connected, check the 'Separate USB/Ext' trace on the back.")
else:
    print("Rail looks OK (>= 4 V). If servo still does not move, try another servo.")
