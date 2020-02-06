#!/usr/bin/env python3
import pandas as pd

data = pd.read_csv('output1.csv',usecols = ['timestamp', 'AccX', 'AccY', 'AccZ'])

df = pd.DataFrame(data) 
	
# Get names of indexes for which column timestamp has repetead values in column AccX
indexNames = df[ df['timestamp'] == df['AccZ'] ].index
 
# Delete these row indexes from dataFrame
df.drop(indexNames , inplace=True)

df.to_csv('data2.csv', encoding='utf-8', index=False)

