
import numpy as np
import matplotlib
import matplotlib.pyplot as plt

# TODO: generate noisy signal

fs = 100 # sample rate 
f = 2 # the frequency of the signal
fn = 2000 # the frequency of the noise

x = np.arange(fs) 
y = np.sin(2*np.pi*f * (x/fs)) + np.sin(2*np.pi*fn * (x/fs)) 

plt.stem(x,y)
plt.plot(x,y)
plt.show()

# TODO: export signal data in determined best format
