#!/usr/bin/env python3
import csv
import time
import multiprocessing
import serial
import bluetooth

running_time = 10
PCB_top_addr = '30:AE:A4:CC:26:12'
port = 1
vectorLen = 6
sensitivity = 2048

def twos_complement(input_value: int, num_bits: int) -> int:
    mask = 2 ** (num_bits - 1)
    return -(input_value & mask) + (input_value & ~mask)

def read_top_PCB(runtime, port, vectorLen, sensitivity):
    start = int(time.time())
    end = int(time.time())
    #bd_addr = "30:AE:A4:CC:26:12"       #top (red mark on top): 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB   

    file = open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/Acc_Data.csv', 'a')

    #sock=bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    #sock.connect((PCB_top_addr, port))
    #print('Top PCB connected.')

    #sock.settimeout(1.0)
    #print('Starting acquisition.')
    sock.send("s")

    while (end - start) < runtime:
        data = sock.recv(1024)
        seconds = int(time.time())

        raw_accX = data[0] << 8 | data[1]
        raw_accY = data[2] << 8 | data[3]
        raw_accZ = data[4] << 8 | data[5]
        #raw_temp = data[6] << 8 | data[7]

        accX = twos_complement(raw_accX,16) / sensitivity
        accY = twos_complement(raw_accY,16) / sensitivity
        accZ = twos_complement(raw_accZ,16) / sensitivity
        #temp = raw_temp * 0.00390625

        file.write(str(seconds) + "," + str(round(accX,2)) + "," + str(round(accY,2)) + "," + str(round(accZ,2)) + "\n")
        #print(data[0]," ",data[1], " | ", data[2], " ", data[3], " | ", data[4], " ", data[5], "\n", data[6], " ", data[7], "\n")
        print(data[0]," ",data[1], " | ", data[2], " ", data[3], " | ", data[4], " ", data[5], "\n")
        #print("AccX: ", accX, "g | AccY: ", accY, "g | AccZ: ", accZ)
        end = int(time.time())

    print('Stopping acquisition.')
    sock.send("x")
    sock.close()
    print('Top PCB  disconected')
    file.close()

# Polar connection
print("Starting acquisition.")

# PCB connection
sock=bluetooth.BluetoothSocket(bluetooth.RFCOMM)
print("Connecting to top PCB...")
sock.connect((PCB_top_addr, port))
print('Top PCB connected.')
sock.settimeout(1.0)

# Create processes
p2 = multiprocessing.Process(target=read_top_PCB,args=(running_time,port,vectorLen,sensitivity))

# Start processes
p2.start()

# Wait until processes are finished
p2.join()

print("Done!\n")