#!/usr/bin/env python3
import chardet    
rawdata = open('HR_Data1.bin', 'rb').read()
result = chardet.detect(rawdata)
charenc = result['encoding']
print(charenc)
