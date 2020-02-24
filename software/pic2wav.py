from PIL import Image
import numpy as np
import scipy.io.wavfile


data = np.asarray(Image.open("ciao.png")) # load RGBA picture
data = data[:, :, 0] # Select a single channel (red)
data = np.vstack((data, data[::-1]))

snd_data = np.empty(1)
for col in data.T:
    inv_fft = np.fft.ifft(col).real/200
    snd_data = np.append(snd_data, inv_fft);

scipy.io.wavfile.write("/tmp/noise.wav", 48000, snd_data)
