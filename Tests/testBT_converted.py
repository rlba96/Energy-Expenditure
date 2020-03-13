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

# https://www.geeksforgeeks.org/invert-actual-bits-number/
def invertBits(num):  
  
    # calculating number of bits in the number  
    x = int(math.log2(num)) + 1
  
    # Inverting the bits one by one  
    for i in range(x):  
        num = (num ^ (1 << i))  
      
    value = num*(-1)

    return value

def twos_complement(input_value: int, num_bits: int) -> int:
    """Calculates a two's complement integer from the given input value's bits."""
    mask = 2 ** (num_bits - 1)
    return -(input_value & mask) + (input_value & ~mask)

start = int(time.time())
end = int(time.time())
runtime = 15
bd_addr = "C4:4F:33:3E:B3:CB" #top: 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB
port = 1
vectorLen = 6
sensitivity = 2048          # 2g-16384; 4g-8192; 8g-4096; 16g-2048; according to the datasheet

file = open('teste.csv', 'a')
sock = bluetooth.BluetoothSocket( bluetooth.RFCOMM )
sock.connect((bd_addr, port))
print('Esp32 connected')

sock.settimeout(1.0)
print('Starting Esp32 acquisition.')
sock.send("s")


while (end - start) < runtime:
    data = sock.recv(1024)
    seconds = int(time.time())
    #print(seconds,',[',data[0],' ',data[1],' ',data[2],' ',data[3],' ',data[4],' ',data[5],']')

    #file.write(str(seconds))
    #file.write(",")
    """
    for x in range(int(vectorLen/2)):
        raw_acc = data[x] << 8 | data[x+1]
        acc = twos_complement(raw_acc,16) / sensitivity
        file.write(str(round(acc,2)))
        if (x < (int(vectorLen/2)-1)):
            file.write(",")
        x = x+2
    """
    raw_accX = data[0] << 8 | data[1]
    raw_accY = data[2] << 8 | data[3]
    raw_accZ = data[4] << 8 | data[5]

    accX = twos_complement(raw_accX,16) / sensitivity
    accY = twos_complement(raw_accY,16) / sensitivity
    accZ = twos_complement(raw_accZ,16) / sensitivity

    print("AccX: ", round(accX,2), "   AccY: ", round(accY,2), "   AccZ: ", round(accZ,2))
    file.write(str(seconds) + "," + str(round(accX,2)) + "," + str(round(accY,2)) + "," + str(round(accZ,2)) + "\n")
    #file.write("\n")
    end = int(time.time())

print('Stopping Esp32 acquisition.')
sock.settimeout(1.0)
sock.send("x")
sock.close()
print('Esp32 disconected')
file.close()
