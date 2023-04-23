#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Feb  3 00:59:47 2022

@author: m.benammar
"""
#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Feb  1 11:09:50 2022

@author: m.benammar
"""
 

from matplotlib import pyplot   as plt
import numpy as np 
from PIL import Image as im


def xor(a,b):
    
    return np.abs(b-a)
   

def LFSR(N,c,seed): 
    LFSR_output = np.zeros(N)
    m = np.size(c)
    state = seed  
    for i in range(0,N): 
        next_bit = np.mod(np.sum(c*state),2)
        LFSR_output[i] = state[m-1]
        state = np.concatenate( (np.array([next_bit]) , state[0:m-1]))
    return LFSR_output  

c = np.array([1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1]) # connections vector
seed = np.array([1,0,1,0,0,1,1,1,0,1,0,1,0,1,1,1]) #initial state   

# Create the stream cipher 
tic = time.time_ns()
stream_cipher = LFSR(np.size(image_binary), c,seed)
toc = time.time_ns()

print((toc-tic)/1000.0)