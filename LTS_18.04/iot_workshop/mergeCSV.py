#!/usr/bin/env python3
import pandas as pd

d_one = pd.read_csv('Dataset_Bitalino.csv',sep=',',engine='python',header=0)
d_two = pd.read_csv('Dataset_MPU6050.csv',sep=',',engine='python',header=0)
d_three = pd.merge(d_one, d_two, left_on='timestamp',right_on='timestamp')
d_three.to_csv('output.csv',sep=',', index=False)
