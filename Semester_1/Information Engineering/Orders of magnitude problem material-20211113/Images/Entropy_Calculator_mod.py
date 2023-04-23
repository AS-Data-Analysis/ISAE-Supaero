#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Nov 11 21:08:25 2021

@author: saumya
"""

from PIL import Image
from math import log2, fabs
import statistics 
import numpy as np
from sklearn import preprocessing


im = Image.open("ISAE_Logo_SEIS_gs.png")
pixel_list= list(im.getdata())

im = Image.open("ISAE_Logo_SEIS_gs_noisy.png")
pixel_list_y= list(im.getdata())

pixel_list_noise = []
for i in range(len(pixel_list)-1):
    pixel_list_noise.append(pixel_list_y[i] - pixel_list[i])

#print(pixel_list_y)
my_dic_y = {}
for i in range(256):
    my_dic_y[i] = 0

for i in pixel_list_y:
        my_dic_y[i] += 1


#print(my_dic_y)
#print

my_dic= {}
for i in range(256):
    my_dic[i] = 0

for i in pixel_list:
        my_dic[i] += 1
        
sum = 0
for frequency in my_dic.values():
    sum+=frequency
for i in my_dic:
    my_dic[i] = my_dic[i]/sum

sum = 0
for frequency in my_dic_y.values():
    sum+=frequency
for i in my_dic_y:
    my_dic_y[i] = my_dic_y[i]/sum


print(my_dic)
print(my_dic_y)

P = np.zeros((256,256))
for i in my_dic:
    for j in my_dic_y:
        P[j][i]=my_dic[i]*my_dic_y[j]
print(P)