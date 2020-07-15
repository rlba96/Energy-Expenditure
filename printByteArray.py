#!/usr/bin/env python3
import numpy
import js2py

def hexStrToInt(hexstr):
    val = (int(hexstr[0:2],16))
    return val

js_func = js2py.eval_js('function(r){var e = r[3]<<24 | r[2]<<16 | r[1]<<8 | r[0], n = new ArrayBuffer(4); return new Int32Array(n)[0] = e, new Float32Array(n)[0]}')

# c0 be 35 41 c2 23 b8 41 3f 3c 2b 3f 00 00 40 40
humon_data = bytes([0x3f, 0x3c, 0x2b, 0x3f])

data = numpy.float32(humon_data[0] | humon_data[1]<<8 | humon_data[2]<<16 | humon_data[3]<<24)

humon_data_str = "3f 3c 2b 3f"

print(humon_data[3])
print(data)
print(js_func(humon_data))