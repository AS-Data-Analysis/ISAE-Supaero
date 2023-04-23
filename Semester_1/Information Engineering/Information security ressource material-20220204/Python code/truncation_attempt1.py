from matplotlib import pyplot as plt
import numpy as np 
from PIL import Image as im   
import itertools
import time

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


image_1 = np.load('image1_binary_crypt_sol_145.npy') #Opening image1
image_2 = np.load('image2_binary_crypt_sol_145.npy') #Opening image2
image_3 = np.load('image3_binary_crypt_sol_145.npy') #Opening image3

sum_1_2 = np.mod(image_1 + image_2,2)
sum_1_2 = np.reshape(sum_1_2,(1,960000))
sum_2_3 = np.mod(image_2 + image_3,2)
sum_2_3 = np.reshape(sum_2_3,(1,960000))
sum_1_3 = np.mod(image_1 + image_3,2)
sum_1_3 = np.reshape(sum_1_3,(1,960000))

# Truncation

Part_1 = image_2[0:15808]
Part_2 = image_2[320000:335808]
Part_3 = image_2[640000:655808]

image_trunc = np.concatenate((Part_1,Part_2,Part_3),axis=None)
image_trunc = np.reshape(image_trunc,(1,47424))

# Brute Force Method on the truncated image
iter=0

list_of_seeds = list(itertools.product(range(2),repeat=16))

for seed in list_of_seeds:
    iter+=1
    start_time = time.time()
    decypher = LFSR(np.size(image_trunc),c,seed)

    image_binary_decrypt = np.mod(image_trunc + decypher,2)
    
    image_rec_plane = np.zeros((13,152,3),dtype=np.uint8)
    image_binary_plane = np.zeros((13*152*8,3))
    
    
    # From binary to image
    image_binary_decrypt_plane = np.reshape(image_binary_decrypt, (13*152*8,3)) 
    for i_plane in range(0,3):     
        ctr = 0
        for i in range(0,13):
            for j in range(0,152):
                image_rec_plane[i,j,i_plane] = (np.sum(image_binary_decrypt_plane[ctr:ctr+8,i_plane]*np.array([128,64,32,16,8,4,2,1]))) 
                ctr += 8
    
    
    # Recovering the image from the array of YCbCr
    image_rec = im.fromarray(image_rec_plane) 
    
    # Plot the image 
    plt.imshow(image_rec)
    plt.show()
    print(iter)
    current_time = time.time()
    print(str(current_time - start_time) + " seconds")