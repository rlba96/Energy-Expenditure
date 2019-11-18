# Project: spyking-circus   Author: spyking-circus   File: utils.py 
# https://www.programcreek.com/python/example/59508/scipy.signal.butter
#!/usr/bin/env python
import numpy as np
import matplotlib.pyplot as plt
import pylab

from scipy import signal


def highpass(data, BUTTER_ORDER=3, sampling_rate=10000, cut_off=500.0):
    Wn = (float(cut_off) / (float(sampling_rate) / 2.0), 0.95)
    b, a = signal.butter(BUTTER_ORDER, Wn, 'pass')
    return signal.filtfilt(b, a, data)


print("BITalino ACC Sample")
x = np.linspace(0.0, 10.0, num=5520)
y = np.loadtxt('opensignals_201512228168_2019-11-06_15-46-56_converted.txt',usecols=5)
#yhat = highpass(y,3,100,0.7)

plt.plot(x,y)
#plt.plot(x,yhat,color='red')
plt.xlabel('t(s)')
plt.ylabel('mg')
plt.title('Acc Samples: 1000Hz 10s')
#plt.gca().legend(('Acc','Filt'))
plt.show()
