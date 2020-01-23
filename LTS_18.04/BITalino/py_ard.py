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
#while True:
while (end - start) < 5:
    line = ser.readline()
    #timestamp = str(time.time())
    timestamp = str(int(time.time()))
    #seconds = math.floor(timestamp)
    #timestamp = str(seconds)
    #timestamp = str(datetime.datetime.fromtimestamp(time.time()).strftime('%Y-%m-%d %H:%M:%S'))
    with open('output.csv', 'a') as pyfile:
        pyfile.write(timestamp + ',')
    with open('output.csv', 'b+a') as pyfile:
        pyfile.write(line)
        #pyfile.write(line + ' ' + timestamp + ' ')
    print(line," Timestamp: ",timestamp)
    print("")
    end = time.time()
    time.sleep(1)

ser.close()
