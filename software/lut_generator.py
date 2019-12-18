import numpy as np

#Conversion to hex
#Ref: https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python
def tohex(val, nbits):
    return hex((val + (1 << nbits)) % (1 << nbits))

f = open("cos.mem", "w")

for i in range(512):
   # f.write("%.9f\n" %int(np.cos(2*np.pi/1024*i)*10**4))
     f.write(tohex(int(np.cos(2*np.pi/1024*i)*10**4),16)[2:]+"\n")
f.close()

f = open("sin.mem", "w")

for i in range(512):
   # f.write("%.9f\n" %int(np.cos(2*np.pi/1024*i)*10**4))
     f.write(tohex(int(-np.sin(2*np.pi/1024*i)*10**4),16)[2:]+"\n")
f.close()
