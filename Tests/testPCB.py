#!/usr/bin/env python3
import csv
import time
import multiprocessing
import serial
import bluetooth

running_time = 20
PCB_top_addr = '30:AE:A4:CC:26:12'
port = 1
vectorLen = 36
sensitivity = 2048

def twos_complement(input_value: int, num_bits: int) -> int:
    mask = 2 ** (num_bits - 1)
    return -(input_value & mask) + (input_value & ~mask)

def read_top_PCB(runtime, port, vectorLen, sensitivity):
    start = int(time.time())
    end = int(time.time())
    #bd_addr = "30:AE:A4:CC:26:12"       #top (red mark on top): 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB   

    #file = open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/Acc_Data_Conv.csv', 'a')
    file2 = open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/Acc_Data_Raw.csv', 'a')

    sock.send("s")

    while (end - start) < runtime:
        data = sock.recv(1024)
        seconds = int(time.time())
        """
        raw_accX_0 = data[0] << 8 | data[1]
        raw_accY_0 = data[2] << 8 | data[3]
        raw_accZ_0 = data[4] << 8 | data[5]

        raw_accX_1 = data[6] << 8 | data[7]
        raw_accY_1 = data[8] << 8 | data[9]
        raw_accZ_1 = data[10] << 8 | data[11]

        raw_accX_2 = data[12] << 8 | data[13]
        raw_accY_2 = data[14] << 8 | data[15]
        raw_accZ_2 = data[16] << 8 | data[17]

        raw_accX_4 = data[18] << 8 | data[19]
        raw_accY_4 = data[20] << 8 | data[21]
        raw_accZ_4 = data[22] << 8 | data[23]

        raw_accX_5 = data[24] << 8 | data[25]
        raw_accY_5 = data[26] << 8 | data[27]
        raw_accZ_5 = data[28] << 8 | data[29]

        raw_accX_6 = data[30] << 8 | data[31]
        raw_accY_6 = data[32] << 8 | data[33]
        raw_accZ_6 = data[34] << 8 | data[35]

        accX_0 = twos_complement(raw_accX_0,16) / sensitivity
        accY_0 = twos_complement(raw_accY_0,16) / sensitivity
        accZ_0 = twos_complement(raw_accZ_0,16) / sensitivity

        accX_1 = twos_complement(raw_accX_1,16) / sensitivity
        accY_1 = twos_complement(raw_accY_1,16) / sensitivity
        accZ_1 = twos_complement(raw_accZ_1,16) / sensitivity

        accX_2 = twos_complement(raw_accX_2,16) / sensitivity
        accY_2 = twos_complement(raw_accY_2,16) / sensitivity
        accZ_2 = twos_complement(raw_accZ_2,16) / sensitivity

        accX_4 = twos_complement(raw_accX_4,16) / sensitivity
        accY_4 = twos_complement(raw_accY_4,16) / sensitivity
        accZ_4 = twos_complement(raw_accZ_4,16) / sensitivity

        accX_5 = twos_complement(raw_accX_5,16) / sensitivity
        accY_5 = twos_complement(raw_accY_5,16) / sensitivity
        accZ_5 = twos_complement(raw_accZ_5,16) / sensitivity

        accX_6 = twos_complement(raw_accX_6,16) / sensitivity
        accY_6 = twos_complement(raw_accY_6,16) / sensitivity
        accZ_6 = twos_complement(raw_accZ_6,16) / sensitivity


        file.write(str(seconds) + "," 
                + str(round(accX_0,3)) + "," 
                + str(round(accY_0,3)) + "," 
                + str(round(accZ_0,3)) + ","
                + str(round(accX_1,3)) + "," 
                + str(round(accY_1,3)) + "," 
                + str(round(accZ_1,3)) + ","
                + str(round(accX_2,3)) + "," 
                + str(round(accY_2,3)) + "," 
                + str(round(accZ_2,3)) + ","
                + str(round(accX_4,3)) + "," 
                + str(round(accY_4,3)) + "," 
                + str(round(accZ_4,3)) + ","
                + str(round(accX_5,3)) + "," 
                + str(round(accY_5,3)) + "," 
                + str(round(accZ_5,3)) + ","
                + str(round(accX_6,3)) + "," 
                + str(round(accY_6,3)) + "," 
                + str(round(accZ_6,3)) + "\n")
        """

        file2.write(str(seconds) + "," 
                + str(data[0]) + "," + str(data[1]) + "," + str(data[2]) + ","
                + str(data[3]) + "," + str(data[4]) + "," + str(data[5]) + "," 
                + str(data[6]) + "," + str(data[7]) + "," + str(data[8]) + ","
                + str(data[9]) + "," + str(data[10]) + "," + str(data[11]) + "," 
                + str(data[12]) + "," + str(data[13]) + "," + str(data[14]) + ","
                + str(data[15]) + "," + str(data[16]) + "," + str(data[17]) + "," 
                + str(data[18]) + "," + str(data[19]) + "," + str(data[20]) + ","
                + str(data[21]) + "," + str(data[22]) + "," + str(data[23]) + ","
                + str(data[24]) + "," + str(data[25]) + "," + str(data[26]) + "," 
                + str(data[27]) + "," + str(data[28]) + "," + str(data[29]) + ","
                + str(data[30]) + "," + str(data[31]) + "," + str(data[32]) + "," 
                + str(data[33]) + "," + str(data[34]) + "," + str(data[35]) + ","
                + "\n")

        # Print data received
        #print(data[0]," ",data[1], " | ", data[2], " ", data[3], " | ", data[4], " ", data[5], "\n", data[6], " ", data[7], "\n")
        #print(data[0]," ",data[1], " | ", data[2], " ", data[3], " | ", data[4], " ", data[5], "\n")
        #print("AccX: ", accX, "g | AccY: ", accY, "g | AccZ: ", accZ)
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