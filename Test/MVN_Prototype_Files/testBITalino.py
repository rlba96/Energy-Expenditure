#!/usr/bin/env python3
import csv
import time
import multiprocessing
import serial
import bitalino
import numpy

running_time = 10
macAddress_BITalino = "98:D3:81:FD:61:22"
samplingFreq_BITalino = 10
acqChannels = [0,1,2,3,4,5]

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

# Polar connection
print("Starting acquisition.")

start_HR = int(time.time())
end_HR = int(time.time())

# BITalino connection
print("Searching for BITalino devices...\n")
device = bitalino.BITalino(macAddress_BITalino)
print("BITalino device " + str(macAddress_BITalino) + " connected.\n")

# Create processes
p1 = multiprocessing.Process(target=read_data_bitalino,args=(samplingFreq_BITalino,running_time))

# Start processes
p1.start()

# Wait until processes are finished
p1.join()

print("Done!\n")