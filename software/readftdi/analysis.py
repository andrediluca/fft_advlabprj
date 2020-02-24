#!/usr/bin/env python
# coding: utf-8

# In[152]:


import numpy as np
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure
import matplotlib


# In[153]:


def orderdered_output(x, npoints = 1024):
    index = list(range(0,npoints)) #genersate index list
    index_bin = [f'{el:010b}' for el in index] #conversion of indeces to binary
    reversed_bin = [el[::-1] for el in index_bin] # REVERSE STUFF
    index_ordered = [int(el,2) for el in reversed_bin] # conversione to int
    ordered_y = [x[i] for i in index_ordered ] #reordering based on index_ordered
    return ordered_y


# In[154]:


#plt.style.use('fivethirtyeight')
npoints = 1024
output_fft = np.fromfile('dout.raw', dtype='uint32')
ncamp = len(output_fft)//npoints
re = np.array((output_fft >> 16) & 0xffff, dtype="int16")
im = np.array( output_fft & 0xffff, dtype="int16")


# In[155]:


re_2d = re[:ncamp*npoints].reshape((ncamp,npoints))
im_2d = im[:ncamp*npoints].reshape((ncamp,npoints))


# In[156]:


re_2d_ordered = [orderdered_output(re_2d[j]) for j in range(ncamp)]
im_2d_ordered = [orderdered_output(im_2d[j]) for j in range(ncamp)]


# In[157]:


ampl = np.array(np.sqrt(np.array(re_2d_ordered, dtype='int64')**2 + np.array(im_2d_ordered, dtype='int64')**2))


# In[158]:


plt.plot(np.arange(1024), ampl[100]/40000.)


# In[159]:


matplotlib.rcParams.update({'font.size': 22})
figure(num=None, figsize=(30, 90), dpi=80, facecolor='w', edgecolor='k')
# plt.imshow(ampl.T)
plt.imshow(np.log(ampl[:,0:511]).T)
plt.xlabel('Time [s]')
plt.ylabel('Frequency [kHz]')
plt.yticks(np.linspace(0,511, 12),np.linspace(0, 24.5, 12, dtype=np.int32))
plt.xticks(np.linspace(0,ampl.shape[0], 10),np.linspace(0,ampl.shape[0]*21/1000., 10, dtype=np.int32))

plt.grid(False)

