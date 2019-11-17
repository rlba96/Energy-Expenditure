import sqlite3
import bitalino
import time
import numpy as np
import matplotlib.pyplot as plt
import pylab

from scipy.signal import savgol_filter

print("BITalino ACC Sample")
x = np.linspace(0.0, 10.0, num=126)
y = np.loadtxt('opensignals_201512228168_2019-11-06_13-23-08.txt')[:,-1]
yhat = savgol_filter(y, 51, 3) # window size 51, polynomial order 3

plt.plot(x,y)
plt.plot(x,yhat,color='red')
plt.xlabel('t(s)')
plt.ylabel('mg')
plt.title('Acc Samples: 1000Hz 10s')
plt.gca().legend(('Acc','Filt'))
plt.show()

