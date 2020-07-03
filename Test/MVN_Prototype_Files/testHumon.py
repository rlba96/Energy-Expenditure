#!/usr/bin/env python3
#http://flowcloud.github.io/ci20-bluetooth-LE/2015/09/10/bluetooth-control-in-python/
#https://mcuoneclipse.com/2016/12/29/using-python-gatttool-and-bluetooth-low-energy-with-hexiwear/
import pexpect
import time
import struct
import binascii
import csv

DEVICE = "CC:06:11:7C:37:2D"
runtime = 15

print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))

fileHumon = open('/home/ap4isr/Desktop/DataAcquisitions/Subj003/Humon_Data.csv','b+a')

# Humon address
print("Humon address: ", DEVICE)

# Run gattool
print("Connecting to ", DEVICE, "...")
child = pexpect.spawn("gatttool -i hci0 -b CC:06:11:7C:37:2D -I -t random")

# Connect to the device
child.sendline("connect")
child.expect(r'Connection successful.*\[LE\]>', timeout=15)
print("Humon device connected!")

start = time.time()
end = time.time()

while (end-start) < runtime:
    space = " "
    child.sendline(r'char-read-hnd 0x0024')
    tstamp = str(int(time.time()))
    child.expect("Characteristic value/descriptor: ", timeout=5)
    child.expect("\r\n", timeout=10)
    print(child.before)
    fileHumon.write(tstamp.encode('utf-8'))
    fileHumon.write(space.encode('utf-8'))
    fileHumon.write(child.before)
    newline = "\n"
    fileHumon.write(newline.encode('utf-8'))
    end = time.time()
    time.sleep(1)

child.sendline("disconnect")
child.sendline("quit")

child.sendline("sudo hciconfig hci0 down")
child.sendline("sudo hciconfig hci0 up")

print("Humon device disconnected.")

fileHumon.close()