#!/usr/bin/env python
import csv

with open('EE_Dataset_Jogging_v1_0.csv', 'w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(["Timestamp", "Name", "Weight", "Activity", "Acceleration", "Heart_Rate", "Oxygen_Saturation", "MET", "Caloric Expenditure"])
