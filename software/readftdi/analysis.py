#!/usr/bin/env python
# coding: utf-8

# In[1]:


import numpy as np
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure


# In[2]:


def orderdered_output(x, npoints = 1024):
    index = list(range(0,npoints)) #genersate index list
    index_bin = [f'{el:010b}' for el in index] #conversion of indeces to binary
    reversed_bin = [el[::-1] for el in index_bin] # REVERSE STUFF
    index_ordered = [int(el,2) for el in reversed_bin] # conversione to int
    ordered_y = [x[i] for i in index_ordered ] #reordering based on index_ordered
    return index, ordered_y


# In[ ]:





# In[3]:


#f = open('sin_1.mem', 'r')
output_fft = np.fromfile('dout.raw', dtype='uint32')
len(output_fft)//1024
#output_fft = f.readlines()
#f.close()


# In[4]:


re = np.array((output_fft >> 16) & 0xffff, dtype="int16")
im = np.array(output_fft & 0xffff, dtype="int16")


# In[5]:


re_2d = re[:1024*163].reshape((163,1024))


# In[6]:


im_2d = im[:1024*163].reshape((163,1024))


# In[7]:


output_fft_im = im[0:1024]
output_fft_re = re[0:1024]


# In[8]:


x_re, y_re = orderdered_output(output_fft_re)
x_im, y_im = orderdered_output(output_fft_im)


# In[9]:


np.max(y_re)


# In[10]:


fig = plt.figure(figsize=(8, 8), facecolor='white') # You were missing the =
# figure(figsize=(20, 16), dpi=160)
plt.plot(x_im, y_im)


# In[11]:


fig = plt.figure(figsize=(8, 8), facecolor='white') # You were missing the =
# figure(figsize=(20, 16), dpi=160)
plt.plot(x_im,np.array(y_im))


# In[12]:


fig= plt.figure(figsize=(20,20))
plt.plot(x_re,np.sqrt(np.array(y_re, dtype='int64')**2 + np.array(y_im, dtype='int64')**2))


# Animate

# In[13]:


def orderdered_output(x, npoints = 1024):
    index = list(range(0,npoints)) #genersate index list
    index_bin = [f'{el:010b}' for el in index] #conversion of indeces to binary
    reversed_bin = [el[::-1] for el in index_bin] # REVERSE STUFF
    index_ordered = [int(el,2) for el in reversed_bin] # conversione to int
    ordered_y = [x[i] for i in index_ordered ] #reordering based on index_ordered
    return ordered_y


# In[14]:


#plt.style.use('fivethirtyeight')
npoints = 1024
output_fft = np.fromfile('dout.raw', dtype='uint32')
ncamp = len(output_fft)//npoints
re = np.array((output_fft >> 16) & 0xffff, dtype="int16")
im = np.array( output_fft & 0xffff, dtype="int16")


# In[15]:


re_2d = re[:ncamp*npoints].reshape((ncamp,npoints))
im_2d = im[:ncamp*npoints].reshape((ncamp,npoints))


# In[16]:


re_2d_ordered = [orderdered_output(re_2d[j]) for j in range(ncamp)]
im_2d_ordered = [orderdered_output(im_2d[j]) for j in range(ncamp)]


# In[17]:


ampl = np.array(np.sqrt(np.array(re_2d_ordered, dtype='int64')**2 + np.array(im_2d_ordered, dtype='int64')**2))


# In[18]:


plt.plot(np.arange(1024), ampl[100]/40000.)


# In[19]:


from matplotlib.pyplot import figure
figure(num=None, figsize=(6, 20), dpi=80, facecolor='w', edgecolor='k')
plt.imshow(np.log(ampl).T)
plt.grid(False)


# In[166]:


np.amin(ampl)


# In[ ]:




