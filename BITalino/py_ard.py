#!/usr/bin/env python3
import serial
import time
import datetime
import math

ser = serial.Serial(
    port='/dev/ttyUSB0',\
    baudrate=115200,\
    parity=serial.PARITY_NONE,\
    stopbits=serial.STOPBITS_ONE,\
    bytesize=serial.EIGHTBITS,\
        timeout=0)

print("connected to: " + ser.portstr)

start = time.time()
end = time.time()

while (end - start) < 5:
    line = ser.readline()
    timestamp = str(int(time.time()))
    with open('output1.csv', 'a') as pyfile:
        pyfile.write(timestamp + ',')
    with open('output1.csv', 'b+a') as pyfile:
        pyfile.write(line)
    print(" Timestamp: ",timestamp, " ",line)
    print("")
    end = time.time()
    #time.sleep(1)

ser.close()
