import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
from scipy.fft import fft, fftfreq, fftshift

fs = 8000 # ksample/s

class CIC:

    def __init__(self, M, N, fs):
        self.M = M
        self.N = N
        self.fs = fs
        self.Hintegrator = None
        self.Hcomb = None
        self.integrator()
        self.comb()

    def integrator(self):
        H = signal.TransferFunction([1], [1, -1], dt=1/self.fs)
        self.Hintegrator = H
        return self

    def comb(self):
        num = np.zeros(self.M * self.N)
        num[0] = 1
        num[-1] = -1
        H =  signal.TransferFunction(num, [1], dt=self.N/self.fs)
        self.Hcomb = H
        return self
    
    def integrate(self, input):
        for _ in range(self.M):
            input = signal.lfilter(self.Hintegrator.num, self.Hintegrator.num, input)
        return input
    
    def downsample(self, input):
        return input[::self.N]

    def differentiate(self, input):
        for _ in range(self.M):
            input = signal.lfilter(self.Hcomb.num, self.Hcomb.den, input)
        return input

    def filter(self, input):
        return self.differentiate(self.downsample(self.integrate(input)))


cic = CIC(1, 8, 8000)
x = np.sin(np.linspace(0, 2 * np.pi, 10))
y = cic.filter(x)

print(np.ptp(x))
print(np.ptp(y))
print(20 * np.log10(np.ptp(y)/np.ptp(x)))


# fig, axs = plt.subplots(2, 2)

# input = np.repeat([0.0], 10000)
# for i in 10 ** np.arange(1, 10):
#     input += np.sin(np.linspace(0, 2 * np.pi * i, 10000))

# filtered = filter(input)

# axs[0, 0].plot(input, label=i)
# axs[0, 1].plot(filtered, label=i)

# input_fft = np.abs(fftshift(fft(input)))
# filtered_fft = np.abs(fftshift(fft(filtered)))

# axs[1, 0].plot(input_fft, label=i)
# axs[1, 1].plot(filtered_fft, label=i)

# plt.show()

   


