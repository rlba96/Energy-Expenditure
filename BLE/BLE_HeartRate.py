#!/usr/bin/env python3
"""
    https://github.com/getsenic/gatt-python
"""
import gatt
import csv
import time

manager = gatt.DeviceManager(adapter_name='hci0')


class AnyDevice(gatt.Device):
    def services_resolved(self):
        super().services_resolved()
        # geonaute hr service uuid:0000180d-0000-1000-8000-00805f9b34fb'
        device_information_service = next(
            s for s in self.services
            if s.uuid == '0000180d-0000-1000-8000-00805f9b34fb')
        #geonaute hr characteristic uuid:00002a37-0000-1000-8000-00805f9b34fb
        firmware_version_characteristic = next(
            c for c in device_information_service.characteristics
            if c.uuid == '00002a37-0000-1000-8000-00805f9b34fb')

        firmware_version_characteristic.read_value()

        firmware_version_characteristic.enable_notifications()

    def characteristic_value_updated(self, characteristic, value):
        seconds = int(time.time())
        print(str(seconds) + "," )
        rri=value[2]|value[3]<<8
        rr=float(rri)/1000-0
        print(value[1], " ", rr)
        with open('HR_Data.csv', 'a') as pyfile:
            pyfile.write(str(seconds) + ',')
        with open("HR_Data.csv",'a') as file:
            writer = csv.writer(file,delimiter = ',')
            writer.writerow([str(value[1]),str(rr)]) 
        

device = AnyDevice(mac_address='D0:41:AF:74:f6:F1', manager=manager)
device.connect()

manager.run()
