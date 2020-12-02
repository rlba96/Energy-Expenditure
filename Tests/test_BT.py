#!/usr/bin/env python3
"""
A simple Python script to receive messages from a client over Bluetooth using PyBluez. 
"""
import bluetooth
import sys
import time
import csv
import numpy as np

start = int(time.time())
end = int(time.time())
runtime = 10
bd_addr = "C4:4F:33:3E:B3:CB"   #top: 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB
port = 1
vectorLen = 12

file = open('teste.csv', 'a')
sock = bluetooth.BluetoothSocket( bluetooth.RFCOMM )
sock.connect((bd_addr, port))
print('Esp32 connected')

sock.settimeout(2.0)
print('Starting Esp32 acquisition.')
sock.send("s")

while (end - start) < runtime:
    data = sock.recv(2048)
    seconds = int(time.time())
    file.write(str(seconds))
    file.write(',')
    for x in range(vectorLen):
    	file.write(str(data[x]))
    	if(x < (vectorLen-1)):
    		file.write(',')
    file.write("\n")
    end = int(time.time())

print('Stopping Esp32 acquisition.')
sock.send("x")
sock.close()
print('Esp32 disconected')
file.close()
