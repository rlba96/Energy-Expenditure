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
import time

from datetime import datetime

def read_data_bitalino(samplingFreq,running_time):

    device.start(samplingFreq, acqChannels)

    start = time.time()
    end = time.time()
    while (end - start) < running_time:
        # Read samples
        dt = int(time.time())
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
        with open('Dataset_Bitalino.csv', 'a') as file:     # Dataset_Bitalino.csv
            writer = csv.writer(file)
            writer.writerow([dt,
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

def read_esp32_BLE_data():
    manager = gatt.DeviceManager(adapter_name='hci0')

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
            with open('Dataset_MPU6050.csv', 'a') as pyfile:    # Dataset_MPU6050.csv
                pyfile.write(str(seconds) + ',')
            with open("Dataset_MPU6050.csv", 'a') as file:
                writer = csv.writer(file,delimiter = '\'')
                writer.writerow([value.decode("utf-8")]) 

    device = AnyDevice(mac_address='30:AE:A4:CC:26:12', manager=manager)
    device.connect()

    manager.run()

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
            #print(value[1], " ", rr)
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
    samplingFreq = 10                   # Sampling Frequency (Hz)
    running_time = 5                    # Acquisition Time (s) - None for Infinite
    acqChannels = [0,1,2,3,4,5]         # Acquisition Channels ([0-5])
    weight = 57

    print("")
    print("Data Collection")
    print("")
    print("Searching for BITalino device...")

    device = bitalino.BITalino(macAddress)
    
    print("")
    print("BITalino Device " + str(macAddress) + " connected.")
    print("")
    print("Starting acquisition.")
    print("")

    # Create processes
    p1 = multiprocessing.Process(target=read_data_bitalino,args=(samplingFreq,running_time))
    p2 = multiprocessing.Process(target=read_esp32_BLE_data)
    p3 = multiprocessing.Process(target=read_HR_BLE_data)

    # Start processes
    p1.start()
    p2.start()
    p3.start()

    # Wait until processes are finished
    p1.join()
    p2.join()
    p3.join()

    print("Done!")