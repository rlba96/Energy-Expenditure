#!/usr/bin/env python3
"""
    Read Esp32 data from a MPU6050 sensor via BLE
    https://github.com/getsenic/gatt-python
"""
import gatt
import csv
import time

start = int(time.time())

manager = gatt.DeviceManager(adapter_name='hci0')

class AnyDevice(gatt.Device):
    def services_resolved(self):
        super().services_resolved()

        device_information_service = next(
            s for s in self.services
            if s.uuid == '6e400001-b5a3-f393-e0a9-e50e24dcca9e')

        firmware_version_characteristic = next(
            c for c in device_information_service.characteristics
            if c.uuid == '6e400003-b5a3-f393-e0a9-e50e24dcca9e')

        firmware_version_characteristic.read_value()

        firmware_version_characteristic.enable_notifications()

    def characteristic_value_updated(self, characteristic, value):
        seconds = int(time.time())
        print(str(seconds) + "," + str(int.from_bytes(value,"little")))
        with open('test.csv', 'a') as pyfile:
            pyfile.write(str(seconds) + ',')
        with open("test.csv",'a') as file:
            writer = csv.writer(file,delimiter = ',') #\'
            #writer.writerow([value.decode("utf-8")])
            writer.writerow([str(int.from_bytes(value,"little"))])
        end = time.time()
        if(end - start) > 15:
            self.disconnect()
            print("Esp32 Acc disconnected")
            self.manager.stop()

device = AnyDevice(mac_address='30:AE:A4:CC:26:12', manager=manager)
device.connect()
print("Esp32 Acc connected")
manager.run()