"""
  Convert the raw data into SmO2 percentage
"""
import csv
import struct

smo2_raw = 'HumonData.csv' 
smo2_converted = "HumonData_Converted.csv"

with open(smo2_raw,'r') as f_r, open(smo2_converted,'w') as f_w:
  reader = csv.reader(f_r)

  for row in reader:
    value = str(row[:1])
    tstamp = value[2:12]
    val = value[46:48] + value[43:45] + value[40:42] + value[37:39]
    smo2 = round(struct.unpack('!f', bytes.fromhex(val))[0]*100,2)
    f_w.write(tstamp)
    f_w.write(",")
    f_w.write(str(smo2))
    f_w.write("\n")

  f_r.close()
  f_w.close()

