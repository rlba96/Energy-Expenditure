# Project: spyking-circus   Author: spyking-circus   File: utils.py 
# https://www.programcreek.com/python/example/59508/scipy.signal.butter
#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt
import pylab

from scipy import signal
from scipy.signal import savgol_filter

def highpass(data, BUTTER_ORDER=3, sampling_rate=100, cut_off=0.7):
    Wn = (float(cut_off) / (float(sampling_rate) / 2.0), 0.95)
    b, a = signal.butter(BUTTER_ORDER, Wn, 'pass')
    return signal.filtfilt(b, a, data)

def smoothTriangle(data, degree):
    triangle=np.concatenate((np.arange(degree + 1), np.arange(degree)[::-1])) # up then down
    smoothed=[]

    for i in range(degree, len(data) - degree * 2):
        point=data[i:i + len(triangle)] * triangle
        smoothed.append(np.sum(point)/np.sum(triangle))
    # Handle boundaries
    smoothed=[smoothed[0]]*int(degree + degree/2) + smoothed
    while len(smoothed) < len(data):
        smoothed.append(smoothed[-1])
    return smoothed

print("BITalino ACC Sample")
x = np.linspace(0.0, 10.0, num=5520)
y = np.loadtxt('opensignals_201512228168_2019-11-06_15-46-56_converted.txt',usecols=5)

yhat = highpass(y,3,100,0.7)    # High Pass flter
yhat_savgol = savgol_filter(y, 51, 3) # Savitzky-Golay filter: window size 51, polynomial order 3
yhat_smooth = smoothTriangle(y, 10)     # Smoothing: degree = 10

plt.plot(x,y)
plt.plot(x,yhat,color='red')
plt.plot(x,yhat_savgol,color='green')
plt.plot(x,yhat_smooth,color='yellow')
plt.xlabel('t(s)')
plt.ylabel('mg')
plt.title('Acc Samples: 1000Hz 10s')
plt.gca().legend(('Acc','HP','Savgol','Smooth'))
plt.show()
