import sqlite3
import bitalino
import time
import numpy as np
import matplotlib.pyplot as plt
import pylab

from scipy.signal import savgol_filter

print("BITalino ACC, OXY and HR Samples")

x_acc = np.linspace(0.0, 10.0, num=5520)
x_oxy = np.linspace(0.0, 10.0, num=5520)
x_hr = np.linspace(0.0, 10.0, num=5520)

y_acc = np.loadtxt('opensignals_201512228168_2019-11-06_15-46-56_converted.txt',usecols=5)
y_oxy = np.loadtxt('opensignals_201512228168_2019-11-06_15-46-56_converted.txt',usecols=6)
y_hr = np.loadtxt('opensignals_201512228168_2019-11-06_15-46-56_converted.txt',usecols=7)

yhat_acc = savgol_filter(y_acc, 51, 3) # window size 51, polynomial order 3
yhat_oxy = savgol_filter(y_oxy, 51, 3) # window size 51, polynomial order 3
yhat_hr = savgol_filter(y_hr, 51, 3) # window size 51, polynomial order 3

#==================================#
# ACC Samples
#==================================#
plt.subplot(1, 3, 1)
plt.plot(x_acc,y_acc)
plt.plot(x_acc,yhat_acc,color='red')
plt.xlabel('t(s)')
plt.ylabel('mg')
plt.title('Acc Samples: 100Hz 10s')
plt.gca().legend(('Acc','Filt'))
#plt.show()

#==================================#
# OXY Samples
#==================================#
plt.subplot(1, 3, 2)
plt.plot(x_oxy,y_oxy)
plt.plot(x_oxy,yhat_oxy,color='red')
plt.xlabel('t(s)')
plt.ylabel('%')
plt.title('Oxy % Samples: 100Hz 10s')
plt.gca().legend(('Oxy %','Filt'))
#plt.show()

#==================================#
# HR Samples
#==================================#
plt.subplot(1, 3, 3)
plt.plot(x_hr,y_hr)
plt.plot(x_hr,yhat_hr,color='red')
plt.xlabel('t(s)')
plt.ylabel('bmp')
plt.title('HR Samples: 100Hz 10s')
plt.gca().legend(('HR','Filt'))
plt.show()

