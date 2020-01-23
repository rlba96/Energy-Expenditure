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
import gatt

from datetime import datetime

def read_data_bitalino(samplingFreq,running_time):
    
    #acqChannels = [0,1,2,3,4,5]         # Acquisition Channels ([0-5])

    #device = bitalino.BITalino(macAddress)
    #print("")
    #print("Device " + str(macAddress) + " connected.")
    #print("")
    device.start(samplingFreq, acqChannels)
    #print("Starting acquisition.")
    #print("")

    start = time.time()
    end = time.time()
    while (end - start) < running_time:
        # Read samples
        seconds = int(time.time())
        dataAcquired = device.read(samplingFreq)
        
        # Acc transfer function: ACC(g) = ((ADC - Cmin)/(Cmax - Cmin))*2-1
        # X = channel 5 --------- 9
        # Y = channel 4 --------- 8
        # Z = channel 3 --------- 7
        max_accX = max(dataAcquired[:,9])
        min_accX = min(dataAcquired[:,9])
        max_accY = max(dataAcquired[:,8])
        min_accY = min(dataAcquired[:,8])
        max_accZ = max(dataAcquired[:,7])
        min_accZ = min(dataAcquired[:,7])

        fill_AccDataX = ((dataAcquired[:,9]-min_accX)/(max_accX-min_accX))*2-1 # BITalino channel 3
        fill_AccDataY = ((dataAcquired[:,8]-min_accY)/(max_accY-min_accY))*2-1 # BITalino channel 3
        fill_AccDataZ = ((dataAcquired[:,7]-min_accZ)/(max_accZ-min_accZ))*2-1 # BITalino channel 3
        
        # HR and SpO2 sat transfer function: 0.25*ADC-0.8
        #fill_HR_oxy = 0.25*dataAcquired[:,6]-0.8    # BITalino channel 2
        fill_SpO2_oxy = 0.25*dataAcquired[:,5]-0.8  # BITalino channel 3
        
        # Mean values
        Acc_meanX = numpy.mean(fill_AccDataX)
        Acc_meanY = numpy.mean(fill_AccDataY)
        Acc_meanZ = numpy.mean(fill_AccDataZ)
        #HR_oxy_mean = numpy.mean(fill_HR_oxy)
        SpO2_oxy_mean = numpy.mean(fill_SpO2_oxy)

        # CSV Format
        with open('EE_Bitalino_Dataset.csv', 'a') as file:
            writer = csv.writer(file)
            for x in range(0,10):
                writer.writerow([seconds,
                                round(fill_AccDataX[x],5),
                                round(fill_AccDataY[x],5),
                                round(fill_AccDataZ[x],5),
                                #round(HR_oxy_mean,2),
                                round(SpO2_oxy_mean)
                                ])
        print("")
        print("Timestamp = ",seconds)
        print("Mean AccZ = ", round(Acc_meanZ,5), "   Mean AccY = ", round(Acc_meanY,5), "   Mean AccX = ",round(Acc_meanX,5))
        print("SpO2 = ",round(SpO2_oxy_mean))
        #for x in range(1,10):
            #print("AccZ = ",fill_AccData[x])
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
        timestamp = str(int(time.time()))

        with open('EE_Esp32Dataset.csv', 'a') as pyfile:
            pyfile.write(timestamp + ',')
        with open('EE_Esp32Dataset.csv', 'b+a') as pyfile:
            pyfile.write(line)

        end = time.time()
        time.sleep(1)

    ser.close()

def read_HR_BLE_data():
    manager = gatt.DeviceManager(adapter_name='hci0')

    class AnyDevice(gatt.Device):
        def services_resolved(self):
            super().services_resolved()

            device_information_service = next(
                s for s in self.services
                if s.uuid == '0000180d-0000-1000-8000-00805f9b34fb')

            # 0x2A37
            firmware_version_characteristic = next(
                c for c in device_information_service.characteristics
                if c.uuid == '00002a37-0000-1000-8000-00805f9b34fb')

            firmware_version_characteristic.read_value()

            firmware_version_characteristic.enable_notifications()

        def characteristic_value_updated(self, characteristic, value):
            seconds = int(time.time())
            rri=value[2]|value[3]<<8
            rr=float(rri)/1000-0
            #print(str(seconds) + "," )
            print("HR = ", value[1], "   rri = ", rr)
            with open('HR_Data.csv', 'a') as pyfile:
                pyfile.write(str(seconds) + ',')
            with open("HR_Data.csv",'a') as file:
                writer = csv.writer(file,delimiter = ',')
                writer.writerow([str(value[1]),str(rr)]) 
            

    device = AnyDevice(mac_address='D0:41:AF:74:F6:F1', manager=manager)
    device.connect()

    manager.run()

if __name__ == "__main__":

    macAddress = "98:D3:81:FD:61:22"    # Device MacAddress: 98:D3:81:FD:61:22 or 20:15:12:22:81:68
    samplingFreq = 10                # Sampling Frequency (Hz)
    running_time = 5                    # Acquisition Time (s) - None for Infinite
    port_name = '/dev/ttyUSB0'
    baud_rate = 115200
    acqChannels = [0,1,2,3,4,5]         # Acquisition Channels ([0-5])

    print("")
    print("Data Collection")
    print("")
    print("Searching for BITalino devices...")

    device = bitalino.BITalino(macAddress)
    
    print("")
    print("Device " + str(macAddress) + " connected.")
    print("")
    print("Starting acquisition.")
    print("")

    # Create processes
    p1 = multiprocessing.Process(target=read_data_bitalino,args=(samplingFreq,running_time))
    #p2 = multiprocessing.Process(target=read_esp32_data,args=(port_name,baud_rate))
    p3 = multiprocessing.Process(target=read_HR_BLE_data)

    # Start processes
    p1.start()
    #p2.start()
    p3.start()

    # Wait until processes are finished
    p1.join()
    #p2.join()
    p3.join()

    print("Done!")