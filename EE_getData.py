#!/usr/bin/env python3

"""
    Script to acquire data from Bitalino and Esp32.
    In main function, set the following parameters:
        -> samplingFreq: 10, 100 or 1000 Hz;
        -> running_time: duration of the acquisition in seconds;
        -> vectorLen: length of the byte array sent from Esp32;
"""

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
import time
import bluetooth
import sys

from datetime import datetime


def read_esp32_BLE_data(running_time):
    manager = gatt.DeviceManager(adapter_name='hci0')
    start = time.time()
    class AnyDevice(gatt.Device):
        def services_resolved(self):
            super().services_resolved()

            device_information_service = next(
                s for s in self.services
                if s.uuid == '6e400001-b5a3-f393-e0a9-e50e24dcca9e')

            firmware_version_characteristic = next(
                c for c in device_information_service.characteristics
                if c.uuid == '6e400003-b5a3-f393-e0a9-e50e24dcca9e')

            firmware_version_characteristic.read_value()

            firmware_version_characteristic.enable_notifications()

        def characteristic_value_updated(self, characteristic, value):
            seconds = int(time.time())
            print("Timestamp = ",str(seconds)," MPU6050 Acc = ",value.decode("utf-8"))
            with open('Dataset_MPU6050.csv', 'a') as pyfile:    # Dataset_MPU6050.csv
                pyfile.write(str(seconds) + ',')
            with open("Dataset_MPU6050.csv", 'a') as file:
                writer = csv.writer(file,delimiter = '\'')
                writer.writerow([value.decode("utf-8")])
            end = time.time()
            if(end - start) > (running_time):
                self.disconnect()
                print("Esp32 disconnected.")
                self.manager.stop()

    device = AnyDevice(mac_address='30:AE:A4:CC:26:12', manager=manager)
    device.connect()
    print("Esp32 connected.")
    manager.run()

def read_HR_BLE_data(running_time):
    manager = gatt.DeviceManager(adapter_name='hci0')
    start = time.time()
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
            #print(value[1], " ", rr)
            with open('HR_Data.csv', 'a') as pyfile:
                pyfile.write(str(seconds) + ',')
            with open("HR_Data.csv",'a') as file:
                writer = csv.writer(file,delimiter = ',')
                writer.writerow([str(value[1]),str(rr)])
            end = time.time() 
            if(end - start) > (running_time):
                self.disconnect()
                print("Esp32 disconnected.")
                self.manager.stop()

    device = AnyDevice(mac_address='D0:41:AF:74:F6:F1', manager=manager)
    device.connect()
    print("Esp32 connected.")
    manager.run()

def read_data_bitalino(samplingFreq,running_time):

    device.start(samplingFreq, acqChannels)

    start = time.time()
    end = time.time()
    while (end - start) < running_time:
        # Read samples
        seconds = int(time.time())
        dataAcquired = device.read(samplingFreq)
        
        # Acc transfer function: ACC(g) = ((ADC - Cmin)/(Cmax - Cmin))*2-1
        max_acc = max(dataAcquired[:,5])    # BITalino channel 1
        min_acc = min(dataAcquired[:,5])    # BITalino channel 1
        fill_AccData = abs(((dataAcquired[:,5]-min_acc)/(max_acc-min_acc))*2-1) # BITalino channel 1
        
        # HR and SpO2 sat transfer function: 0.25*ADC-0.8
        #fill_HR_oxy = 0.25*dataAcquired[:,6]-0.8    # BITalino channel 2
        #fill_SpO2_oxy = 0.25*dataAcquired[:,7]-0.8  # BITalino channel 3
        
        # Mean values
        Acc_mean = numpy.mean(fill_AccData)
        #HR_oxy_mean = numpy.mean(fill_HR_oxy)
        #SpO2_oxy_mean = numpy.mean(fill_SpO2_oxy)

        # CSV Format
        with open('testBitalino.csv', 'a') as file:
            writer = csv.writer(file)
            for x in range(0,samplingFreq):
                writer.writerow([seconds,
                                #round(fill_AccDataX[x],5),
                                #round(fill_AccDataY[x],5),
                                round(fill_AccData[x],5)
                                #round(HR_oxy_mean,2),
                                #round(SpO2_oxy_mean)
                                ])
        print("Timestamp = ",seconds," AccZ = ",Acc_mean)
        end = time.time()

    device.stop()           # Stop acquisition
    device.close()          # Close connection
    print("BITalino connection closed.")

def read_esp32_data(running_time, port, vectorLen):
    start = int(time.time())
    end = int(time.time())
    bd_addr = "30:AE:A4:CC:26:12"

    file = open('testeBT.csv', 'a')
    sock = bluetooth.BluetoothSocket( bluetooth.RFCOMM )
    sock.connect((bd_addr, port))
    print('Esp32 connected')

    sock.settimeout(1.0)
    print('Starting Esp32 acquisition.')
    sock.send("s")

    while (end - start) < running_time:
        data = sock.recv(1024)
        seconds = int(time.time())
        #print(seconds,data)

        file.write(str(seconds))
        file.write(",")
        for x in range(vectorLen):
            file.write(str(data[x]))
            if (x < (vectorLen-1)):
                file.write(",")
        file.write("\n")
        end = int(time.time())

    print('Stopping Esp32 acquisition.')
    sock.settimeout(1.0)
    sock.send("x")
    sock.close()
    print('Esp32 disconected')
    file.close()

if __name__ == "__main__":

    macAddress = "98:D3:81:FD:61:22"     # Bitalino MacAddress: 98:D3:81:FD:61:22 or 20:15:12:22:81:68
    samplingFreq = 10                    # Sampling Frequency (Hz)
    running_time = 20                    # Acquisition Time (s) - None for Infinite
    running_timeEsp = 25
    acqChannels = [0,1,2,3,4,5]          # Acquisition Channels ([0-5])
    port = 1
    vectorLen = 10

    print("")
    print("Data Collection")
    print("")
    print("Searching for BITalino device...")

    device = bitalino.BITalino(macAddress)
    
    print("")
    print("BITalino Device " + str(macAddress) + " connected.")
    print("")
    print("Starting BITalino acquisition.")
    print("")

    # Create processes
    p1 = multiprocessing.Process(target=read_data_bitalino,args=(samplingFreq,running_time))
    #p2 = multiprocessing.Process(target=read_esp32_BLE_data,args=(running_timeEsp,))
    #p3 = multiprocessing.Process(target=read_HR_BLE_data,args=(running_time,))
    p4 = multiprocessing.Process(target=read_esp32_data,args=(running_time,port,vectorLen))

    # Start processes
    p1.start()
    #p2.start()
    #p3.start()
    p4.start()

    # Wait until processes are finished
    p1.join()
    #p2.join()
    #p3.join()
    p4.join()

    print("Done!")
