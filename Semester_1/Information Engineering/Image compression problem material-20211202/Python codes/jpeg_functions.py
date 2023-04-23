#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue May 18 09:51:38 2021

@author: m.benammar
"""
import numpy as np 
import numpy.matlib


zg_matrix = np.array([[1,2,6,7,15,16,28,29],
    [3,5,8,14,17,27,30,43],
    [4, 9,13,18,26,31,42,44],
    [10,12,19,25,32,41,45,54],
    [11,20,24,33,40,46,53,55],
    [21,23,34,39,47,52,56,61],
    [22,35,38,48,51,57,60,62],
    [36,37,49,50,58,59,63,64]],dtype=np.int32) -1;

def quantization_matrix(Q):
    Tb = np.array([[16, 11, 10, 16 ,24, 40, 51, 61], [12, 12 ,14 ,19, 26, 58, 60, 55], 
         [14, 13, 16 ,24, 40, 57, 69 ,56], [14 ,17 ,22 ,29 ,51 ,87 ,80, 62], 
         [18 ,22 ,37 ,56, 68 ,109, 103, 77], [24 ,35 ,55, 64, 81, 104, 113, 92], 
         [49, 64 ,78 ,87 ,103, 121, 120, 101], [72 ,92, 95, 98, 112, 100, 103 ,99]])
    if Q < 50 :
        S = 5000/Q
    else:
        S = 200 - 2*Q 
    
    Ts = np.floor((S*Tb + 50) / 100) 
    Ts[Ts == 0] = 1 
    return Ts
def DCT(M_ij):
 
    n_row = np.size(M_ij,0)
    n_col = np.size(M_ij,1)

    C_u = np.concatenate((np.array([1.0/np.sqrt(2)]), np.ones(n_row -1)),axis = 0)
    C_u_rep = np.matlib.repmat(C_u, n_row, 1) 
    C_uv = 1/np.sqrt(2*n_row)*C_u_rep*np.transpose(C_u_rep )
     
    T = np.zeros((n_row, n_col)) 
    for u in range(0,n_row) :
        for v in range(0,n_col) :
            C_ijuv = np.zeros((n_row, n_col))
            for i  in range(0,n_row)   :
                for j in range(0,n_col)   : 
                  C_ijuv[i,j] = M_ij[i,j] * np.cos((u)*np.pi/n_row* ((i) + .5))* np.cos((v)*np.pi/n_col* ((j) + .5))  
            
            T[u,v] = np.sum(np.sum(C_ijuv)) 
    
    res = C_uv*T;
    
    return res
 
def DCT_inv(T_uv):
 
    n_row = np.size(T_uv,0)
    n_col = np.size(T_uv,1)

    C_i = np.concatenate((np.array([1.0/np.sqrt(2)]), np.ones(n_row -1)),axis = 0)
    C_i_rep = np.matlib.repmat(C_i, n_row, 1) 
    C_ij = 1/np.sqrt(2*n_row)*C_i_rep*np.transpose(C_i_rep )
     
    M = np.zeros((n_row, n_col)) 
    for i in range(0,n_row) :
        for j in range(0,n_col) :
            C_ijuv = np.zeros((n_row, n_col))
            for u  in range(0,n_row)   :
                for v in range(0,n_col)   : 
                  C_ijuv[u,v] = T_uv[u,v]*C_ij[u,v] *np.cos((u)*np.pi/n_row* ((i) + .5))* np.cos((v)*np.pi/n_col* ((j) + .5))  
            
            M[i,j] = np.sum(np.sum(C_ijuv)) 
    
    res = M;
    
    return res
  

def zigzag(image_block):
    image_block_zgzg = np.zeros(64)
    for i_r in range(0,8): 
        for i_c in range(0,8): 
            image_block_zgzg[zg_matrix[i_r,i_c]]= image_block[i_r,i_c]
    return image_block_zgzg

def zigzag_inv(image_block_zgzg):
    image_block = np.zeros((8,8))
    for i_r in range(0,8): 
        for i_c in range(0,8): 
            image_block[i_r,i_c] = image_block_zgzg[zg_matrix[i_r,i_c]] 
    return image_block

# test zigzag 
image= np.random.randint(0,255,(8,8))
image_zg = zigzag(image)
image_block_est = zigzag_inv(image_zg)


def DC_category(x): 
    if np.abs(x) < 10**(-3):
        cat = 0
    else: 
        cat = (np.floor(np.log2(np.abs(x)))+ 1.0 ).astype(np.int32)
    return cat
DC_category_vect = np.vectorize(DC_category)

def DC_amplitude(x):
    if np.abs(x) < 10**(-3):
        amp = '0'
    k =  DC_category(x)
    if x > 0.0 :
      amp =  np.binary_repr(x, k) 
    if x < 0.0 :
      amp =  np.binary_repr(  2**k- 1 +x, k)
    return amp 
DC_amplitude_vect = np.vectorize(DC_amplitude)

def cat_ampl_to_DC (x,y):
    y_int = int(y,2)
    if x == 0 :
        DC_value= 0 
    else: 
        if y_int< (2**(x-1)):
          DC_value =  y_int- 2**x+1
        else :
          DC_value=  y_int  
    return DC_value
cat_ampl_to_DC_vect = np.vectorize(cat_ampl_to_DC)

def RLE(AC_coeff):
    ctr= 0
    N_AC = np.size(AC_coeff) 
    output_rl =np.array([[0,0]])
    output_amp = {}
    ind_ecr = 0
    for i in range(0, N_AC):  
        if ((AC_coeff[i] == 0) & (ctr<15) & ( i < N_AC-1) ):
            ctr+= 1 
        else:   
            new_output = np.array([[ctr,DC_category(AC_coeff[i])]])
            output_rl = np.concatenate((output_rl, new_output),axis= 0)
            new_ampl = DC_amplitude(AC_coeff[i])
            output_amp[ind_ecr] = new_ampl
            ctr= 0
            ind_ecr+= 1 
    return [output_rl, output_amp]  

def RLE_inv(decompressed_cat_AC,AC_coeff_amp):
    N_AC = np.size(decompressed_cat_AC,0)  
    output  =np.array([]) 
    for i in range(1, N_AC): 
        run_value = decompressed_cat_AC[i,0]
        cat_value = decompressed_cat_AC[i,1]
        ampl_value = AC_coeff_amp[i-1]
        value = cat_ampl_to_DC (cat_value,ampl_value)
        output = np.concatenate((output, np.zeros(run_value),  np.array([value]))) 
    return output