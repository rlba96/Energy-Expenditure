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

from datetime import datetime

running_time = 15 

def read_data_bitalino(samplingFreq,running_time):

    device.start(samplingFreq, acqChannels)

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
        max_accZ = max(dataAcquired[:,5])
        min_accZ = min(dataAcquired[:,5])
        fill_AccDataZ = ((dataAcquired[:,5]-min_accZ)/(max_accZ-min_accZ))*2-1 # BITalino channel 3
        
        # HR and SpO2 sat transfer function: 0.25*ADC-0.8
        #fill_HR_oxy = 0.25*dataAcquired[:,6]-0.8    # BITalino channel 2
        #fill_SpO2_oxy = 0.25*dataAcquired[:,5]-0.8  # BITalino channel 3
        
        # Mean values (to print)
        Acc_meanZ = numpy.mean(fill_AccDataZ)
        #HR_oxy_mean = numpy.mean(fill_HR_oxy)
        #SpO2_oxy_mean = numpy.mean(fill_SpO2_oxy)

        # CSV Format
        with open('EE_Bitalino_Dataset.csv', 'a') as file:
            writer = csv.writer(file)
            for x in range(0,10):
                writer.writerow([seconds,
                                round(fill_AccDataZ[x],5)
                                #round(HR_oxy_mean,2),
                                #round(SpO2_oxy_mean)
                                ])
        print("")
        print("Timestamp = ",seconds," AccZ = ",Acc_meanZ)
        #print("SpO2 = ",round(SpO2_oxy_mean))
        end = time.time()

    device.stop()           # Stop acquisition
    device.close()          # Close connection
    print("BITalino connection closed.")

def read_top_PCB(runtime, port, vectorLen, sensitivity):
    start = int(time.time())
    end = int(time.time())
    #bd_addr = "30:AE:A4:CC:26:12"       #top (red mark on top): 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB   

    #file = open('EE_top_PCB_Dataset .csv', 'a')

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
        raw_temp = data[6] << 8 | data[7]

        accX = twos_complement(raw_accX,16) / sensitivity
        accY = twos_complement(raw_accY,16) / sensitivity
        accZ = twos_complement(raw_accZ,16) / sensitivity
        temp = raw_temp * 0.00390625

        file.write(str(seconds) + "," + str(round(accX,2)) + "," + str(round(accY,2)) + "," + str(round(accZ,2)) + "\n")
        #print(data[0]," ",data[1], " | ", data[2], " ", data[3], " | ", data[4], " ", data[5], "\n", data[6], " ", data[7], "\n")
        #print("AccX: ", accX, "g | AccY: ", accY, "g | AccZ: ", accZ)
        end = int(time.time())

    print('Stopping acquisition.')
    sock.send("x")
    sock.close()
    print('Top PCB  disconected')
    file.close()


def twos_complement(input_value: int, num_bits: int) -> int:
    """Calculates a two's complement integer from the given input value's bits."""
    mask = 2 ** (num_bits - 1)
    return -(input_value & mask) + (input_value & ~mask)

class AnyDevice(gatt.Device):
    def connect_succeeded(self):
        super().connect_succeeded()
        print("[%s] Connected" % (self.mac_address))

    def connect_failed(self, error):
        super().connect_failed(error)
        print("[%s] Connection failed: %s" % (self.mac_address, str(error)))

    def services_resolved(self):
        super().services_resolved()
        # Heart rate service uuid:0000180d-0000-1000-8000-00805f9b34fb'
        device_information_service = next(
            s for s in self.services
            if s.uuid == '0000180d-0000-1000-8000-00805f9b34fb')
        # Heart rate characteristic uuid:00002a37-0000-1000-8000-00805f9b34fb
        firmware_version_characteristic = next(
            c for c in device_information_service.characteristics
            if c.uuid == '00002a37-0000-1000-8000-00805f9b34fb')

        firmware_version_characteristic.read_value()

        firmware_version_characteristic.enable_notifications()

    def characteristic_value_updated(self, characteristic, value):
        seconds = int(time.time())
        rri=value[2]|value[3]<<8
        rr=float(rri)/1000-0
        fileHR = open("EE_HR_Dataset.csv",'a')
        fileHR.write(str(seconds) + "," + str(value[1]) + "," + str(rr) + "\n")
        print(str(seconds), " HR: ", value[1], " bpm | RRI: ", rr, " ms")
        end = int(time.time())
        if(end_HR - start_HR) > 15:
            self.disconnect()
            self.manager.stop()
            print("\nGeonaute disconnected")

def read_Geonaute_HR():
    manager.run()

if __name__ == "__main__":

    macAddress_BITalino = "98:D3:81:FD:61:22"           # Device MacAddress: 98:D3:81:FD:61:22 or 20:15:12:22:81:68
    samplingFreq_BITalino = 10                          # Sampling Frequency (Hz)
    acqChannels = [0,1,2,3,4,5]                         # Acquisition Channels ([0-5])
    port = 1
    vectorLen = 8
    sensitivity = 2048
    PCB_top_addr = "30:AE:A4:CC:26:12"       #top (red mark on top): 30:AE:A4:CC:26:12    low:C4:4F:33:3E:B3:CB 
    Geonaute_addr = 'D0:41:AF:74:F6:F1'

    print("\nData Collection")

    file = open('EE_top_PCB_Dataset .csv', 'a')
    #fileHR = open("EE_HR_Dataset.csv",'a')

    print("\nSearching for BITalino devices...")

    device = bitalino.BITalino(macAddress_BITalino)
    
    print("\nBITalino device " + str(macAddress_BITalino) + " connected.")

    sock=bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    print("\nConnecting to top PCB...")
    sock.connect((PCB_top_addr, port))
    print('\nTop PCB connected.')

    sock.settimeout(1.0)

    manager = gatt.DeviceManager(adapter_name='hci0')
    deviceHR = AnyDevice(mac_address=Geonaute_addr, manager=manager)

    print("\nConnecting to Geonaute HR...")
    deviceHR.connect()
    print("\nGeonaute HR connected.")

    start_HR = int(time.time())
    end_HR = int(time.time())

    print("\nStarting acquisition.\n")

    # Create processes
    p1 = multiprocessing.Process(target=read_data_bitalino,args=(samplingFreq_BITalino,running_time))
    p2 = multiprocessing.Process(target=read_top_PCB,args=(running_time,port,vectorLen,sensitivity))
    p3 = multiprocessing.Process(target=read_Geonaute_HR)

    # Start processes
    p1.start()
    p2.start()
    p3.start()

    # Wait until processes are finished
    p1.join()
    p2.join()
    p3.join()

    print("Done!\n")