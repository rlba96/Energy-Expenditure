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

running_time = 1200 

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
        if(end_HR - start_HR) > running_time:
            self.disconnect()
            self.manager.stop()
            print("\nPolar H7 disconnected")

def read_PolarH7_HR():
    manager.run()

def read_data_bitalino(samplingFreq,running_time):

    device.start(samplingFreq, acqChannels)

    start = time.time()
    end = time.time()
    while (end - start) < running_time:
        # Read samples
        seconds = int(time.time())
        dataAcquired = device.read(samplingFreq)
        
        # EDA transfer function: EDA(us) = [((ADC * Vcc) / (2^n)) / (0.132)] * (10^(-6))
        EDA_data = (((dataAcquired[:,5]*3.3)/(2**10))/0.132)*(10**(-6)) # BITalino channel 3
        
        # Mean values (to print)
        EDA_mean = numpy.mean(EDA_data)

        # CSV Format
        with open('EE_Bitalino_Dataset.csv', 'a') as file:
            writer = csv.writer(file)
            for x in range(0,10):
                writer.writerow([seconds, round(EDA_data[x],5)])
        print("")
        print("Timestamp = ",seconds," EDA = ",EDA_mean)
        end = time.time()

    device.stop()           # Stop acquisition
    device.close()          # Close connection
    print("BITalino connection closed.")

def read_top_PCB(runtime, port, vectorLen, sensitivity):
    start = int(time.time())
    end = int(time.time())

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


if __name__ == "__main__":

    macAddress_BITalino = "98:D3:81:FD:61:22"           # BITalino MAC Address
    samplingFreq_BITalino = 10                          # Sampling Frequency (Hz)
    acqChannels = [0,1,2,3,4,5]                         # Acquisition Channels ([0-5])
    port = 1
    vectorLen = 8
    sensitivity = 2048
    PCB_top_addr = "30:AE:A4:CC:26:12"                  # MAC address of the microcontroller ESP32 incorporated in the designed PCB
    PolarH7_addr = 'D0:41:AF:74:F6:F1'                  # Polar H7 MAC address

    print("\nData Collection")

    file = open('EE_top_PCB_Dataset .csv', 'a')

    # Search for BITalino devices
    print("\nSearching for BITalino devices...")
    device = bitalino.BITalino(macAddress_BITalino)
    print("\nBITalino device " + str(macAddress_BITalino) + " connected.")

    sock=bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    print("\nConnecting to top PCB...")
    sock.connect((PCB_top_addr, port))
    print('\nTop PCB connected.')

    sock.settimeout(1.0)

    manager = gatt.DeviceManager(adapter_name='hci0')
    deviceHR = AnyDevice(mac_address=PolarH7_addr, manager=manager)

    print("\nConnecting to Polar H7...")
    deviceHR.connect()
    print("\Polar H7 connected.")

    start_HR = int(time.time())
    end_HR = int(time.time())

    print("\nStarting acquisition.\n")

    # Create processes
    p1 = multiprocessing.Process(target=read_data_bitalino,args=(samplingFreq_BITalino,running_time))
    p2 = multiprocessing.Process(target=read_top_PCB,args=(running_time,port,vectorLen,sensitivity))
    p3 = multiprocessing.Process(target=read_PolarH7_HR)

    # Start processes
    p1.start()
    p2.start()
    p3.start()

    # Wait until processes are finished
    p1.join()
    p2.join()
    p3.join()

    print("Done!\n")
