#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Jan  7 17:23:50 2022

@author: m.benammar
"""
#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
@author: meryem
"""
import numpy as np  
import matplotlib.pyplot as plt 
import math 
 

i_code = 4

# --------------------------------------- Useful functions --------------------------------------
def create_codebook(G):
    k= G.shape[0] # number of input bits
    n= G.shape[1] # number of output bits 
    # Obtain all possible binary words of length k
    int_array = np.arange(0,2**k,dtype= np.uint8).reshape(( 2**k,1))
    bin_matrix = np.unpackbits(int_array,axis=1)
    bin_words = bin_matrix[:,8-k:8]
    codebook= np.zeros((2**k,n), dtype=float)
    for i_word in range(0,2**k):
            codebook[i_word,:]= np.mod(bin_words[i_word,:].dot(G), 2) 
    return [codebook,bin_words]   

def encode(b, G):  
    n= G.shape[1] # size of each codeword  
    N_blocks = b.shape[0] # number of codewords
    c = np.zeros((N_blocks,n), dtype=float)
    for i_block in range(0,N_blocks):
        c[i_block,:]= np.mod(b[i_block,:].dot(G), 2) 
    return c 

# -------------------------  Students need to construct this ----------------------- 
# Generator matrix of the code (G must be of the size (k,n), with k<8)

G1 = np.array([[1]])                                                               
G2 = np.array([[1,1,1]])                                                           
G3 = np.array([[1,0,0,0,1,1,0],[0,1,0,0,1,0,1],[0,0,1,0,0,1,1],[0,0,0,1,1,1,1]])    
G4 = np.array([[1,0,0,1,0,1,1,0,0],[0,1,0,1,0,1,0,1,0],[0,0,1,1,0,0,1,1,0]])        

G_t = [G1,G2,G3,G4]
# ------------------------------------------------------------------------------------------

for C in range(4):
    G = G_t[C]
    
    # Parameters of the code
    k = G.shape[0] # number of input bits
    n = G.shape[1] # number of output bits 
    [codebook, messages] = create_codebook(G) # list of possible codewords
    
    # Number of words (in the Monte Carlo simulation)  
    num_simus = 1000000 #  
    
    # Eb/N_0 ratios for simulations
    EbN0_dB_start = 0 
    EbN0_dB_stop  = 10
    EbN0_points = 4
    EbN0 = np.linspace(EbN0_dB_start ,EbN0_dB_stop ,EbN0_points) 
     
    # Initialization of variables  
    errors_MAP= np.zeros(len(EbN0),dtype=int) 
    nb_errors_MAP = np.zeros(len(EbN0),dtype=int) 
    
    for i_EbN0 in range(0,len(EbN0)): 
        
        # SMessage source  
        binary_messages = np.random.randint(0,2,size=(num_simus,k)) 
    
        # Encoder
        coded_messages = encode(binary_messages,G)
        
        # Modulator (BPSK)
        signal_transm = -2*coded_messages + 1
    
        # Channel (AWGN)
        # Compute the variance of the noise
        sigma  = np.sqrt(float(1)/2/((k/n)*10**(EbN0[i_EbN0]/10))) 
        # Generate the noise
        Noise = sigma*np.random.standard_normal(signal_transm.shape)
        # Add the noise
        signal_receiv = signal_transm + Noise
        
        # MAP Decoding
        binary_messages_estimated = np.zeros(binary_messages.shape)
        
        # ------------------------  Students need to code the MAP  -----------------------------
         
        # MAP Decoding
        
        dem_signal = (signal_receiv-1)/(-2)
        
        signal_transm_estimated = np.zeros(dem_signal.shape)
        
        for i in range(dem_signal.shape[0]):
            for j in range(dem_signal.shape[1]):
                x = dem_signal[i][j]
                prob0=np.exp(-0.5*((x-(0))/sigma)**2)/(sigma*np.sqrt(2*np.pi))
                prob1=np.exp(-0.5*((x-(1))/sigma)**2)/(sigma*np.sqrt(2*np.pi))
                signal_transm_estimated[i][j] = np.argmax(np.array([[prob0,prob1]]))
                
        binary_messages_estimated=signal_transm_estimated[:,0:k]
        
        #Error computation
        errorBi=np.zeros(binary_messages.shape)
        errorBl=0
        for i in range(binary_messages.shape[0]):
            diff_sum=0
            for j in range(binary_messages.shape[1]):
                diff=binary_messages_estimated[i][j]-binary_messages[i][j]
                diff_sum+=diff
                if diff==0:
                    errorBi[i,j]=0
                else:
                    errorBi[i,j]=1
                if diff_sum>0:
                    errorBl+=1
                    
            
        # Compute the number of bits errors
        nb_errors_MAP[i_EbN0]=sum(sum(errorBi))
        # Compute the number of block errors
        errors_MAP[i_EbN0]=errorBl
        # --------------------------------------------------------------------------------------
        
    # Normalize to obtain the number of bit and block errors
       
        # Compute the number of bits errors
        
        # Compute the number of block errors
     
        # --------------------------------------------------------------------------------------
        
    # Normalize to obtain the number of bit and block errors
    BER =  nb_errors_MAP/(k*num_simus)
    BLER = errors_MAP/num_simus 

# PLot the BER 
plt.plot(EbN0, BER)  
plt.plot(EbN0, BLER)  
plt.yscale('log')
plt.xlabel('$E_b/N_0$')
plt.ylabel('BER')    
plt.grid(True)
plt.show()
np.save('BER_C'+str(i_code)+'.npy',BER)
np.save('BLER_C'+str(i_code)+'.npy',BLER)
np.save('EbN0_C'+str(i_code)+'.npy',EbN0)
