#!/usr/bin/env python3
import math
import numpy
import serial
import time
import requests
import json
import csv
import bitalino
import multiprocessing 

from datetime import datetime

def read_data_bitalino(macAddress,samplingFreq,running_time):
    print("")
    print("BITalino Data Collection")
    print("")
    print("Searching for devices...")
    
    acqChannels = [0,1,2,3,4,5]         # Acquisition Channels ([0-5])
    weight = 57

    device = bitalino.BITalino(macAddress)
    print("")
    print("Device " + str(macAddress) + " connected.")
    print("")
    device.start(samplingFreq, acqChannels)
    print("Starting acquisition.")
    print("")

    start = time.time()
    end = time.time()
    while (end - start) < running_time:
        # Read samples
        dataAcquired = device.read(samplingFreq)
        
        # Acc transfer function: ACC(g) = ((ADC - Cmin)/(Cmax - Cmin))*2-1
        max_acc = max(dataAcquired[:,5])
        min_acc = min(dataAcquired[:,5])
        fill_AccData = abs(((dataAcquired[:,5]-min_acc)/(max_acc-min_acc))*2-1) # BITalino channel 1
        
        # HR and SpO2 sat transfer function: 0.25*ADC-0.8
        #fill_HR_oxy = 0.25*dataAcquired[:,6]-0.8    # BITalino channel 2
        #fill_SpO2_oxy = 0.25*dataAcquired[:,7]-0.8  # BITalino channel 3
        
        # Mean values
        Acc_mean = numpy.mean(fill_AccData)
        #HR_oxy_mean = numpy.mean(fill_HR_oxy)
        #SpO2_oxy_mean = numpy.mean(fill_SpO2_oxy)

        # CSV Format
        dt = datetime.today()
        with open('EE_Dataset_pyArd.csv', 'a') as file:
            writer = csv.writer(file)
            writer.writerow([int(dt.timestamp()),
                            "Ricardo",
                            weight,
                            "Rest",
                            round(Acc_mean,5)#,
                            #round(HR_oxy_mean,2),
                            #round(SpO2_oxy_mean,2)
                            ])
        end = time.time()

    device.stop()           # Stop acquisition
    device.close()          # Close connection
    print("Connection closed.")

def read_esp32_data(port_name,baud_rate):
    ser = serial.Serial(port=port_name,baudrate=baud_rate,parity=serial.PARITY_NONE,stopbits=serial.STOPBITS_ONE,bytesize=serial.EIGHTBITS,timeout=0)
    #print("connected to: " + ser.portstr)

    start = time.time()
    end = time.time()

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
        #print(line," Timestamp: ",timestamp)
        #print("")
        end = time.time()
        time.sleep(1)

    ser.close()

if __name__ == "__main__":

    macAddress = "98:D3:81:FD:61:22"    # Device MacAddress: 98:D3:81:FD:61:22 or 20:15:12:22:81:68
    samplingFreq = 10                   # Sampling Frequency (Hz)
    running_time = 5                    # Acquisition Time (s) - None for Infinite
    port_name = '/dev/ttyUSB0'
    baud_rate = 115200

    # Create processes
    p1 = multiprocessing.Process(target=read_data_bitalino,args=(macAddress,samplingFreq,running_time))
    p2 = multiprocessing.Process(target=read_esp32_data,args=(port_name,baud_rate))
    
    # Start processes
    p1.start()
    p2.start()

    # Wait until processes are finished
    p1.join()
    p2.join()

    print("Done!")