#!/usr/bin/env python3
import pygatt
import time
import csv
from binascii import hexlify

adapter = pygatt.GATTToolBackend()
start = int(time.time())
end = int(time.time())

def handle_data(handle, value):
    """
    handle -- integer, characteristic read handle the data was received on
    value -- bytearray, the data returned in the notification
    """
    seconds = int(time.time())
    #print("Received data: %s" % hexlify(value))
    print(seconds,", %s" % str(int.from_bytes(value,"little")))

    writer = csv.writer(file,delimiter = ',')
    writer.writerow([str(seconds),str(int.from_bytes(value,"little"))])
    #writer.writerow([value.decode("utf-8")])
    end = int(time.time())
    if(end-start) > 5:
        return

try:
    file = open('Data.csv', 'a')
    adapter.start()
    device = adapter.connect('30:AE:A4:CC:26:12')
    while (end-start) < 5:
	    device.subscribe("beb5483e-36e1-4688-b7f5-ea07361b26a8",
	                     callback=handle_data)
finally:
    adapter.stop()

