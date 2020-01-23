#!/usr/bin/env python3
import requests
import csv
import json
import math

from datetime import datetime

dt = datetime.today()
seconds = math.floor(dt.timestamp())

print("Sending values to mongodb sensors")
print("Timestamp = ", seconds)
print("")

# Send values to mongodb
data_v = {"name": "Teste"}
headers = {'Content-type': 'application/json'}
data_json = json.dumps(data_v)
r = requests.post(url = "http://127.0.0.1:3000/sensors", data = data_json, headers = headers)
response_db = r.text
print("Response: %s",response_db)
