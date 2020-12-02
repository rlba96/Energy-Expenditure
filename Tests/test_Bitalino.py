#!/usr/bin/env python3
import math
import numpy
import time
import csv
import bitalino
import multiprocessing

from datetime import datetime

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
    print("Connection closed.")


if __name__ == "__main__":

    macAddress = "98:D3:81:FD:61:22"     # Device MacAddress: 98:D3:81:FD:61:22 or 20:15:12:22:81:68
    samplingFreq = 10                    # Sampling Frequency (Hz)
    running_time = 10                    # Acquisition Time (s) - None for Infinite
    acqChannels = [0,1,2,3,4,5]          # Acquisition Channels ([0-5])

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

    # Start processes
    p1.start()

    # Wait until processes are finished
    p1.join()

    print("Done!")
