import sqlite3
import bitalino
import time
import numpy

print("BITalino Data Collection")
time.sleep(2)

# Database
database = "data.db"
#database = "C:\Users\User\Desktop\Teste\SQlite_example"

# Device MacAddress: BLE = 88:6B:0F:94:45:D5, Blt = 20:15:12:22:81:68
macAddress = "20:15:12:22:81:68"

# Acquisition Channels ([0-5])
acqChannels = [0,1,2,3,4,5]

# Sampling Frequency (Hz)
samplingFreq = 1000

# Compute Average Time (s)
timeCycle = 1

# Acquisition Time (s) - None for Infinite
acquisitionTime = 5


database = sqlite3.connect(database)
cursor = database.cursor()

# Restart Database
cursor.execute("Drop table Configuration")
cursor.execute("Drop table Data")

try:
    cursor.execute("CREATE TABLE Configuration(Id INTEGER PRIMARY KEY, MacAddress TEXT, SamplingFreq INT, InitTime TEXT, timeCycle INT, acqChannels TEXT, channelSize INT)")
    cursor.execute("CREATE TABLE Data(Configuration INT, Time INT, Channel0 REAL, Channel1 REAL, Channel2 REAL, Channel3 REAL, Channel4 REAL, Channel5 REAL, FOREIGN KEY(Configuration) REFERENCES Configuration(Id))")
except Exception as e:
    pass

device = bitalino.BITalino(macAddress)
device.start(samplingFreq, acqChannels)
print("Device connected.")

cursor.execute("INSERT INTO Configuration(MacAddress, SamplingFreq, InitTime, timeCycle, acqChannels, channelSize) VALUES" +
               "('" + macAddress + "'," + str(samplingFreq) + ",'" + time.strftime("%c") + "', " + str(timeCycle) + ",'" + str(acqChannels) + "'," + str(len(acqChannels)) + ");")
database.commit()

lastIndex = cursor.lastrowid
print("Current Configuration ID: " + str(lastIndex))

currentTime = 0
while (acquisitionTime is None) or (acquisitionTime > 0):
    avg_data = [lastIndex, currentTime, None, None, None, None, None, None]
    data = device.read(samplingFreq*timeCycle)
    for ind in range(5, data.shape[1]):
        avg_data[acqChannels[ind - 5] + 2] = numpy.mean(numpy.fabs(data[:,ind]))
        # Aply transfer function here;
    cursor.execute("INSERT INTO Data(Configuration, Time, Channel0, Channel1, Channel2, Channel3, Channel4, Channel5) VALUES" +
                    "(" + str(avg_data).replace("None", "null")[1:-1] + ");")
    database.commit()
    currentTime += timeCycle
    if acquisitionTime is not None:
        acquisitionTime -= timeCycle

device.stop()
device.close()

# UnComment to Print Tables

print("")
print("Configurations:")

cursor.execute("Select * from Configuration")
for config in cursor.fetchall():
    print(config)

print("")
print("Data:")

cursor.execute("Select * from Data")
for data in cursor.fetchall():
    print(data)

print("Program will close in 10 seconds.")
time.sleep(10)
