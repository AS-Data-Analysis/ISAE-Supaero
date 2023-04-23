# -*- coding: utf-8 -*-
"""
Created on Tue Nov 16 21:26:25 2021

@author: Seonghyun
"""

import skimage.io
import numpy as np


X = skimage.io.imread(fname="ISAE_Logo_SEIS_gs.png")
Y = skimage.io.imread(fname="ISAE_Logo_SEIS_gs_noisy.png")


rowNum = X.shape[0]
columnNum = X.shape[1]

bandwidth = 500 #Hz

noises = np.int32(Y) - np.int32(X)
se = 0 # sum of square noises(errors)

for i in range(rowNum):
    for j in range(columnNum):
            se += noises[i][j]**2


squareX = 0 # sum of square X
for i in range(rowNum):
    for j in range(columnNum):
        squareX += int(X[i][j])**2

snr = squareX/se # SNR = sum of square X / sum of square noises(errors)
MaxBitRate = bandwidth*np.log2(1+snr)
print(f"Maximum Bit Rate is {MaxBitRate.round(3)}bps")

np.plt(X)