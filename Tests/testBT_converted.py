#!/usr/bin/env python3
"""
A simple Python script to receive messages from a client over 
Bluetooth using PyBluez (with Python 2). 
"""
import bluetooth
import sys
import time
import csv
import math

def invertBits(num):  
  
    # calculating number of bits in the number  
    x = int(math.log2(num)) + 1
  
    # Inverting the bits one by one  
    for i in range(x):  
        num = (num ^ (1 << i))  
      
    value = num*(-1)

    return value

start = int(time.time())
end = int(time.time())
runtime = 15
bd_addr = "30:AE:A4:CC:26:12" #itade address
port = 1
vectorLen = 6
sensitivity = 2048          # 2g-16384; 4g-8192; 8g-4096; 16g-2048; according to the datasheet

file = open('testeBT_MPU.csv', 'a')
sock = bluetooth.BluetoothSocket( bluetooth.RFCOMM )
sock.connect((bd_addr, port))
print('Esp32 connected')

sock.settimeout(1.0)
print('Starting Esp32 acquisition.')
sock.send("s")


while (end - start) < runtime:
    data = sock.recv(1024)
    seconds = int(time.time())
    print(seconds,',[',data[0],' ',data[1],' ',data[2],' ',data[3],' ',data[4],' ',data[5],']')

    file.write(str(seconds))
    file.write(",")

    for x in range(int(vectorLen/2)):
        if(data[x] > 127 & data[x+1] > 127):
            MSB = invertBits(data[x])
            LSB = invertBits(data[x+1])
            acc = (MSB << 8 | LSB)/sensitivity
            #acc = (data[x] << 8 | data[x+1])/sensitivity
            file.write(str(round(acc,2)))

        if(data[x] > 127 & data[x+1] <= 127):
            MSB = invertBits(data[x])
            LSB = data[x+1]
            acc = (MSB << 8 | LSB)/sensitivity
            #acc = (data[x] << 8 | data[x+1])/sensitivity
            file.write(str(round(acc,2)))

        if(data[x] <= 127 & data[x+1] > 127):
            MSB = data[x]
            LSB = invertBits(data[x+1])
            acc = (MSB << 8 | LSB)/sensitivity
            #acc = (data[x] << 8 | data[x+1])/sensitivity
            file.write(str(round(acc,2)))

        if(data[x] <= 127 & data[x+1] <= 127):
            MSB = data[x]
            LSB = data[x+1]
            acc = (MSB << 8 | LSB)/sensitivity
            #acc = (data[x] << 8 | data[x+1])/sensitivity
            file.write(str(round(acc,2)))

        if (x < (int(vectorLen/2)-1)):
            file.write(",")

        x = x+2
    
    file.write("\n")
    end = int(time.time())

print('Stopping Esp32 acquisition.')
sock.settimeout(1.0)
sock.send("x")
sock.close()
print('Esp32 disconected')
file.close()