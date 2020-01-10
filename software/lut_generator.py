import numpy as np

#Conversion to hex
#Ref: https://stackoverflow.com/questions/7822956/how-to-convert-negative-integer-value-to-hex-in-python
def tohex(val, nbits):
    return hex((val + (1 << nbits)) % (1 << nbits))

frequency = [1000, 10000]
npoints = 1024
nbits = 8
for freq in frequency:
    cos_name = "cos_%d.mem" %freq
    sin_name = "sin_%d.mem"%freq

    f = open(cos_name, "w")
    for i in range(npoints):
       # f.write("%.9f\n" %int(np.cos(2*np.pi/1024*i)*10**4))
         f.write(tohex(int(np.cos(2*np.pi/npoints*i * freq)*10**4),nbits)[2:]+"\n")
    f.close()

    f = open(sin_name, "w")

    for i in range(npoints):
       # f.write("%.9f\n" %int(np.cos(2*np.pi/1024*i)*10**4))
         f.write(tohex(int(-np.sin(2*np.pi/npoints*i * freq)*10**4),nbits)[2:]+"\n")
    f.close()
