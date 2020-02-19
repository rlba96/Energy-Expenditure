#!/usr/bin/env python3
"""
A simple Python script to receive messages from a client over 
Bluetooth using PyBluez (with Python 2). 
"""
import bluetooth
import sys
import time
import csv

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
    #print(seconds,data)
    print(seconds,',[',data[0],' ',data[1],' ',data[2],' ',data[3],' ',data[4],' ',data[5],']')
    """
    print(seconds,',[',data[0],' ',data[1],' ',data[2],' ',data[3],' ',data[4],' ',
    				   data[5],' ',data[6],' ',data[7],' ',data[8],' ',data[9],' ',
    				   data[10],' ',data[11],' ',data[12],' ',data[13],' ',data[14],' ',
    				   data[15],' ',data[16],' ',data[17],' ',data[18],' ',data[19],' ',
    				   data[20],' ',data[21],' ',data[22],' ',data[23],' ',data[24],' ',
    				   data[25],' ',data[26],' ',data[27],' ',data[28],' ',data[29],']'
    				   )
    """
    #writer = csv.writer(file,delimiter = ',')
    #writer.writerow([str(seconds),str(int.from_bytes(data,"little"))])
    #writer.writerow([str(seconds),str(data.decode("utf-8"))])
    #writer.writerow([str(seconds),str(data[0]),str(data[1]),str(data[2]),str(data[3])])
    file.write(str(seconds))
    file.write(",")
    """
    for x in range(vectorLen):
    	file.write(str(data[x]))
    	if (x < (vectorLen-1)):
    		file.write(",")
    """
    for x in range(int(vectorLen/2)):
        acc = (data[x] << 8 | data[x+1])/sensitivity
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