#!/usr/bin/env python3
import csv
import time
import multiprocessing
import serial

running_time = 10

def read_Polar_HR(running_time):
    ser = serial.Serial(port='/dev/ttyUSB0',
                        baudrate=115200,
                        parity=serial.PARITY_NONE,
                        stopbits=serial.STOPBITS_ONE,
                        bytesize=serial.EIGHTBITS,
                        timeout=0)
    start = time.time()
    end = time.time()

    while (end - start) < running_time:
        line = ser.readline()
        timestamp = str(int(time.time()))
        with open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/HR_Data.csv', 'a') as pyfile:
            pyfile.write(timestamp + ',')
        with open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/HR_Data.csv', 'b+a') as pyfile:
            pyfile.write(line)
        print(timestamp, "", line.decode('utf-8'))
        end = time.time()
        time.sleep(1)

    ser.close()

# Polar connection
print("Starting acquisition.")

start_HR = int(time.time())
end_HR = int(time.time())

# Create processes
p3 = multiprocessing.Process(target=read_Polar_HR,args=(running_time,))

# Start processes
p3.start()

# Wait until processes are finished
p3.join()

print("Done!\n")
