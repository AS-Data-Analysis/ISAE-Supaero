# -*- coding: utf-8 -*-
"""
Created on Fri Feb  4 11:22:52 2022

@author: ajale
"""

from matplotlib import pyplot as plt
import numpy as np 
from PIL import Image as im   
from itertools import product
from scipy import stats

# Initializations 
image_rec_plane = np.zeros((200,200,3),dtype=np.uint8)
image_binary_plane = np.zeros((200*200*8,3))

crypt_binary_array = ['image1_binary_crypt_sol_145.npy', 'image2_binary_crypt_sol_145.npy', 'image3_binary_crypt_sol_145.npy']

    
crypt_data_dict = {}
crypt_image_list = []


for code in crypt_binary_array: 
    data = np.load(code)
    data = np.array([data])
    crypt_data_dict[code] = np.reshape(data,(200*200*8,3)) 
   

for data in crypt_data_dict:   
    for i_plane in range(0,3):     
        ctr = 0
        for i in range(0,200):
            for j in range(0,200):
                image_rec_plane[i,j,i_plane] = (np.sum(crypt_data_dict[data][ctr:ctr+8,i_plane]*np.array([128,64,32,16,8,4,2,1]))) 
                ctr += 8
            
    image_rec = im.fromarray(image_rec_plane) 
    crypt_image_list.append(image_rec)
    
# Plot the images 
for images in crypt_image_list:
    plt.imshow(images)
    plt.show()
    
#%%
# Absolute subtraction of crypted images equivalent to XOR
def image_subtraction(image1, image2):
    subtracted_images = abs(crypt_data_dict[image1] - crypt_data_dict[image2])
    
    #plot the subtracted images data
    for i_plane in range(0,3):     
        ctr = 0
        for i in range(0,200):
            for j in range(0,200):
                image_rec_plane[i,j,i_plane] = (np.sum(subtracted_images[ctr:ctr+8,i_plane]*np.array([128,64,32,16,8,4,2,1]))) 
                ctr += 8
    
    image_extracted = im.fromarray(image_rec_plane)
    plt.imshow(image_extracted)
    plt.show()

Subt_image_1_2 = image_subtraction('image1_binary_crypt_sol_145.npy','image2_binary_crypt_sol_145.npy')

Subt_image_2_3 = image_subtraction('image2_binary_crypt_sol_145.npy','image3_binary_crypt_sol_145.npy')

Subt_image_1_3 = image_subtraction('image1_binary_crypt_sol_145.npy', 'image3_binary_crypt_sol_145.npy')

#%%

# XOR of crypted images

# def XOR_images(image1, image2):
    
#     image_rec_plane1 = np.zeros((200,200,3),dtype=np.uint8)
#     image_rec_plane2 = np.zeros((200,200,3),dtype=np.uint8)
#     #plot the XOR images data
#     for i_plane in range(0,3):     
#         ctr = 0
#         for i in range(0,200):
#             for j in range(0,200):
#                 image_rec_plane1[i,j,i_plane] = (np.sum(crypt_data_dict[image1][ctr:ctr+8,i_plane]*np.array([128,64,32,16,8,4,2,1]))) 
#                 image_rec_plane2[i,j,i_plane] = (np.sum(crypt_data_dict[image2][ctr:ctr+8,i_plane]*np.array([128,64,32,16,8,4,2,1]))) 
#                 ctr += 8
#     XOR_images = np.bitwise_xor(image_rec_plane1, image_rec_plane2)
#     image_extracted = im.fromarray(XOR_images)
#     plt.imshow(image_extracted)
#     plt.show()
    
# XOR_image_1_2 = XOR_images('image1_binary_crypt_sol_145.npy','image2_binary_crypt_sol_145.npy')

# XOR_image_2_3 = XOR_images('image2_binary_crypt_sol_145.npy','image3_binary_crypt_sol_145.npy')

# XOR_image_1_3 = XOR_images('image1_binary_crypt_sol_145.npy','image3_binary_crypt_sol_145.npy')

#%%

#Brute force to find the seed 
# Iter all the possible combinations of the seed and compare mutual information of the two images. 
# Seed that has minimum mutual information is our key 


# def LFSR(N,c,seed): 
#     LFSR_output = np.zeros(N)
#     m = np.size(c)
#     state = seed  
#     for i in range(0,N): 
#         next_bit = np.mod(np.sum(c*state),2)
#         LFSR_output[i] = state[m-1]
#         state = np.concatenate( (np.array([next_bit]) , state[0:m-1]))
#     return LFSR_output  

# c = np.array([1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1]) # connections vector

# seed_list = product(range(2), repeat=16)

# decryp_dict = {}
# iterations = 0

# for seed in seed_list: 
#     seed = np.array(seed)
    
#     image_code = 'image1_binary_crypt_sol_145.npy'
#     image_binary_crypt = np.load(image_code)
#     image_binary_crypt = np.array([image_binary_crypt])
#     image_crypt_data = np.reshape(image_binary_crypt,(200*200*8,3)) 
    
#     stream_cipher = LFSR(np.size(image_binary_crypt),c,seed) 
#     image_binary_decrypt = np.mod(image_binary_crypt+1*stream_cipher,2)
    
#     image_binary_decrypt_plane = np.reshape(image_binary_decrypt, (200*200*8,3))
#     for i_plane in range(0,3):     
#         ctr = 0
#         for i in range(0,200):
#             for j in range(0,200):
#                 image_rec_plane[i,j,i_plane] = (np.sum(image_binary_decrypt_plane[ctr:ctr+8,i_plane]*np.array([128,64,32,16,8,4,2,1]))) 
#                 ctr += 8
                
#         image_extracted = im.fromarray(image_rec_plane)
#         gray_image = image_extracted.convert('L')
        
#         histogram_gray_image, bin_edges_gray = np.histogram(gray_image, bins=256)
#         prob_occurrence_gray_image = histogram_gray_image/sum(histogram_gray_image)
#         image_entropy = stats.entropy(prob_occurrence_gray_image,qk=None,base=2,axis=0)
        
#     decryp_dict[str(seed)] = image_entropy
#     iterations += 1 
#     print(iterations)

#%%

# Looking for consecutive 16 similar bits between two images 

# bits = 16
# e = 0

# crypted_binary_img1 = np.load('image1_binary_crypt_sol_145.npy')
# crypted_binary_img2 = np.load('image2_binary_crypt_sol_145.npy')

# result = str(crypted_binary_img1[(e*bits):(16+e*bits)]) == str(crypted_binary_img2[(e*bits):(16+e*bits)])

# while result is False: 
#     e += 1
#     result = str(crypted_binary_img1[(e*bits):(16+e*bits)]) == str(crypted_binary_img2[(e*bits):(16+e*bits)])
    
# first_16_similar_bits = crypted_binary_img1[e*bits:(16+e*bits)]
    
# def LFSR(N,c,seed): 
#     LFSR_output = np.zeros(N)
#     m = np.size(c)
#     state = seed  
#     for i in range(0,N): 
#         next_bit = np.mod(np.sum(c*state),2)
#         LFSR_output[i] = state[m-1]
#         state = np.concatenate( (np.array([next_bit]) , state[0:m-1]))
#     return LFSR_output  
    
# c = np.array([1,0,0,1,0,0,0,0,0,0,0,0,1,0,1,1]) # connections vector
# binary_seeds_array = crypted_binary_img1[e*bits:(16+e*bits)]

# seed_element = 305
# while seed_element <= 2**16+16-1: 
#     binary_seeds_arrray.insert()
    
    
    
# stream_cipher = LFSR(np.size(crypted_binary_img1),c,seed) 
# img1_binary_decrypt = np.mod(crypted_binary_img1+1*stream_cipher,2)

# image_binary_decrypt_plane = np.reshape(img1_binary_decrypt, (200*200*8,3))
# for i_plane in range(0,3):     
#     ctr = 0
#     for i in range(0,200):
#         for j in range(0,200):
#             image_rec_plane[i,j,i_plane] = (np.sum(image_binary_decrypt_plane[ctr:ctr+8,i_plane]*np.array([128,64,32,16,8,4,2,1]))) 
#             ctr += 8
            
#     img1_extracted = im.fromarray(image_rec_plane)
#     plt.imshow(img1_extracted)
    
    
#%%

# stupid trick to find the cipher 
crypted_binary_img1 = np.load('image1_binary_crypt_sol_145.npy')

seed_list = product(range(2), repeat=16)

list_seeds = []
for seeds in seed_list: 
    list_seeds.append(seeds)

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
our_seed = list_seeds[145]

our_cipher =LFSR(np.size(crypted_binary_img1),c,our_seed) 

img1_binary_decrypt = np.mod(crypted_binary_img1+1*our_cipher,2)

image_binary_decrypt_plane = np.reshape(img1_binary_decrypt, (200*200*8,3))
for i_plane in range(0,3):     
    ctr = 0
    for i in range(0,200):
        for j in range(0,200):
            image_rec_plane[i,j,i_plane] = (np.sum(image_binary_decrypt_plane[ctr:ctr+8,i_plane]*np.array([128,64,32,16,8,4,2,1]))) 
            ctr += 8
            
    img1_extracted = im.fromarray(image_rec_plane)
    plt.imshow(img1_extracted)
    
    