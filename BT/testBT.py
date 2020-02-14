#!/usr/bin/env python3
"""
A simple Python script to receive messages from a client over 
Bluetooth using PyBluez (with Python 2). 
"""
import bluetooth
import sys
bd_addr = "30:AE:A4:CC:26:12" #itade address

port = 1
sock=bluetooth.BluetoothSocket( bluetooth.RFCOMM )
sock.connect((bd_addr, port))
print('Connected')
sock.settimeout(1.0)
sock.send("x")
print('Sent data')

while True:
    data = sock.recv(1024)
    print('received [%s]'%data)

sock.close()
