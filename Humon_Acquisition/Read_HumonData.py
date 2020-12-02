#!/usr/bin/env python3
import pexpect
import time
import struct
import binascii
import csv
import numpy

DEVICE = "CC:06:11:7C:37:2D"    # Device MAC address
runtime = 120                   # Acquisition duration, in seconds

# Local time
print(time.strftime("%Y-%m-%d %H:%M:%S", time.localtime()))

# File to save the data (16 byte array)
fileHumon = open('HumonData.csv','b+a')

# Humon address
print("Humon address: ", DEVICE)

# Run gattool
print("Run gatttool...")
child = pexpect.spawn("gatttool -i hci0 -b CC:06:11:7C:37:2D -I -t random")

# Connect to the device
child.sendline("connect")
child.expect(r'Connection successful.*\[LE\]>', timeout=5)
print("Humon device connected!")

start = time.time()
end = time.time()

while (end-start) < runtime:
	# Read characteristic value
	child.sendline(r'char-read-hnd 0x0027')
	child.expect("Characteristic value/descriptor: ", timeout=5)
	child.expect("\r\n", timeout=10)
	print(child.before)
	print(child.before[0:5])
	print(child.before[6:11])
	print(child.before[12:17])
	fileHumon.write(child.before)
	line = "\n"
	fileHumon.write(line.encode('utf-8'))
	end = time.time()
	time.sleep(1)

child.sendline("disconnect")
child.sendline("quit")

child.sendline("sudo hciconfig hci0 down")
child.sendline("sudo hciconfig hci0 up")

print("Humon device disconnected.")

fileHumon.close()

