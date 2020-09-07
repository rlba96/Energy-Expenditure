#!/usr/bin/env python3
import csv
import time
import multiprocessing
import serial
import bluetooth

running_time = 10
PCB_top_addr = '30:AE:A4:CC:26:12'
port = 1
vectorLen = 30
sensitivity = 2048

def twos_complement(input_value: int, num_bits: int) -> int:
    mask = 2 ** (num_bits - 1)
    return -(input_value & mask) + (input_value & ~mask)

def read_top_PCB(runtime, port, vectorLen, sensitivity):
    start = int(time.time())
    end = int(time.time())
    #bd_addr = "30:AE:A4:CC:26:12"       #top (red mark on top): 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB   

    #file = open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/Acc_Data_Conv.csv', 'a')
    file2 = open('Acc_Data_Raw_5CH_delay.csv', 'a')

    sock.send("s")

    while (end - start) < runtime:
        data = sock.recv(1024)
        seconds = int(time.time())

        # Write to file
        file2.write(str(seconds) 
                + "," + str(data[0]) + "," + str(data[1]) + "," + str(data[2]) + "," + str(data[3]) + "," + str(data[4]) + "," + str(data[5]) 
                + "," + str(data[6]) + "," + str(data[7]) + "," + str(data[8]) + "," + str(data[9]) + "," + str(data[10]) + "," + str(data[11])
                + "," + str(data[12]) + "," + str(data[13]) + "," + str(data[14]) + "," + str(data[15]) + "," + str(data[16]) + "," + str(data[17]) 
                + "," + str(data[18]) + "," + str(data[19]) + "," + str(data[20]) + "," + str(data[21]) + "," + str(data[22]) + "," + str(data[23])
                + "," + str(data[24]) + "," + str(data[25]) + "," + str(data[26]) + "," + str(data[27]) + "," + str(data[28]) + "," + str(data[29])
                #+ "," + str(data[30]) + "," + str(data[31]) + "," + str(data[32]) + "," + str(data[33]) + "," + str(data[34]) + "," + str(data[35])
                + "\n")

        # Print data received
        #print(data[18]," ",data[19], " | ", data[20], " ", data[21], " | ", data[22], " ", data[23], "\n")
        #print(data[24]," ",data[25], " | ", data[26], " ", data[27], " | ", data[28], " ", data[29], "\n")
        end = int(time.time())

    print('Stopping acquisition.')
    sock.send("x")
    sock.close()
    print('Top PCB  disconected')
    #file.close()
    file2.close()

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