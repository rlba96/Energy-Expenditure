#!/usr/bin/env python3
import math
import numpy
import time
import csv
import bitalino
import multiprocessing
import bluetooth
import sys
import gatt
import serial
import pexpect
import struct
import binascii

from datetime import datetime

from bluepy.btle import Peripheral, ADDR_TYPE_RANDOM, AssignedNumbers, ADDR_TYPE_PUBLIC

running_time = 10

def read_data_bitalino(samplingFreq,running_time):
    device.start(samplingFreq, acqChannels)

    start = time.time()
    end = time.time()

    while (end - start) < running_time:
        # Read samples
        seconds = int(time.time())
        dataAcquired = device.read(samplingFreq)

        # EDA transfer function:  X = channel 1 --------- dataAcquired[:,5]
        #   R = 1-(ADC/2^n)
        #   EDA = 1/R
        R = 1-(dataAcquired[:,5]/pow(2,10))
        EDA = 1/dataAcquired[:,5]
        
        # Mean values (to print)
        EDA_mean = numpy.mean(EDA)

        # CSV Format
        with open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/EDA_Data.csv', 'a') as file:
            writer = csv.writer(file)
            for x in range(0,10):
                writer.writerow([seconds,
                                round(EDA[x],5)
                                ])
        print("")
        print("Timestamp = ",seconds," EDA = ",EDA_mean)
        #print(dataAcquired[:,5])
        end = time.time()

    device.stop()           # Stop acquisition
    device.close()          # Close connection
    print("BITalino connection closed.")

def read_Polar_HR(running_time):
    ser = serial.Serial(port='/dev/ttyUSB0',
                        baudrate=115200,
                        parity=serial.PARITY_NONE,
                        stopbits=serial.STOPBITS_ONE,
                        bytesize=serial.EIGHTBITS,
                        timeout=0)
    #print("connected to: " + ser.portstr)
    start = time.time()
    end = time.time()

    while (end - start) < running_time:
        line = ser.readline()
        timestamp = str(int(time.time()))
        with open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/HR_Data.csv', 'a') as pyfile:
            pyfile.write(timestamp + ',')
        with open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/HR_Data.csv', 'b+a') as pyfile:
            pyfile.write(line)
        #print(str(line)," Timestamp: ",timestamp)
        #print("")
        print(timestamp, "", line.decode('utf-8'))
        end = time.time()
        time.sleep(1)

    ser.close()

def read_Humon(running_time):
    fileHumon = open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/Humon_Data.csv','b+a')
    print("Connecting to ", Humon_addr, "...")
    child = pexpect.spawn("gatttool -i hci0 -b CC:06:11:7C:37:2D -I -t random")
    child.sendline("connect")
    child.expect(r'Connection successful.*\[LE\]>', timeout=15)
    print("Humon device connected!")

    start_Humon = time.time()
    end_Humon = time.time()

    while (end_Humon-start_Humon) < running_time:
        space = " "
        child.sendline(r'char-read-hnd 0x0024')
        tstamp = str(int(time.time()))
        child.expect("Characteristic value/descriptor: ", timeout=5)
        child.expect("\r\n", timeout=10)
        print(child.before)
        fileHumon.write(tstamp.encode('utf-8'))
        fileHumon.write(space.encode('utf-8'))
        fileHumon.write(child.before)
        newline = "\n"
        fileHumon.write(newline.encode('utf-8'))
        end_Humon = time.time()
        time.sleep(1)

    child.sendline("disconnect")
    child.sendline("quit")
    print("Humon device disconnected.")
    child.sendline("sudo hciconfig hci0 down")
    child.sendline("sudo hciconfig hci0 up")
    fileHumon.close()

def read_top_PCB(runtime, port, vectorLen, sensitivity):
    start = int(time.time())
    end = int(time.time())
    #bd_addr = "30:AE:A4:CC:26:12"       #top (red mark on top): 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB   

    file = open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/Acc_Data.csv', 'a')

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
        #print(data[0]," ",data[1], " | ", data[2], " ", data[3], " | ", data[4], " ", data[5], "\n")
        #print("AccX: ", accX, "g | AccY: ", accY, "g | AccZ: ", accZ)
        end = int(time.time())

    print('Stopping acquisition.')
    sock.send("x")
    sock.close()
    print('Top PCB  disconected')
    file.close()

def twos_complement(input_value: int, num_bits: int) -> int:
    mask = 2 ** (num_bits - 1)
    return -(input_value & mask) + (input_value & ~mask)


if __name__ == "__main__":

    macAddress_BITalino = "98:D3:81:FD:61:22"           # Device MacAddress: 98:D3:81:FD:61:22 or 20:15:12:22:81:68
    samplingFreq_BITalino = 10                          # Sampling Frequency (Hz)
    acqChannels = [0,1,2,3,4,5]                         # Acquisition Channels ([0-5])
    port = 1
    vectorLen = 8
    sensitivity = 2048
    PCB_top_addr = "30:AE:A4:CC:26:12"       #top (red mark on top): 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB 
    #Geonaute_addr = 'D0:41:AF:74:F6:F1'
    Humon_addr = "CC:06:11:7C:37:2D"
    
    print("Body Energy Expenditure Data Collection\n")

    # BITalino connection
    print("Searching for BITalino devices...\n")
    device = bitalino.BITalino(macAddress_BITalino)
    print("BITalino device " + str(macAddress_BITalino) + " connected.\n")

    # PCB connection
    sock=bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    print("Connecting to top PCB...")
    sock.connect((PCB_top_addr, port))
    print('Top PCB connected.')
    sock.settimeout(1.0)

    # Humon Hex connection
    print("Starting acquisition.")

    start_HR = int(time.time())
    end_HR = int(time.time())

    # Create processes
    p1 = multiprocessing.Process(target=read_data_bitalino,args=(samplingFreq_BITalino,running_time))
    p2 = multiprocessing.Process(target=read_top_PCB,args=(running_time,port,vectorLen,sensitivity))
    p3 = multiprocessing.Process(target=read_Polar_HR,args=(running_time,))
    p4 = multiprocessing.Process(target=read_Humon,args=(running_time,))

    # Start processes
    p1.start()
    p2.start()
    p3.start()
    p4.start()

    # Wait until processes are finished
    p1.join()
    p2.join()
    p3.join()
    p4.join()

    print("Done!\n")