#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Tue Apr 17 09:54:45 2018
Imported from Jerome Lacan's page 
Adapted by Meryem Benammar
"""

import random
import numpy as np
def dict_freq_numbers(list_image_cat,Alphabet):
    # Image_cat and Alphabet have to be lists
    dicoAlphabet = {} 
    nbr_chr = 0
    for letter in Alphabet:
        nbr_chr += list_image_cat.count(letter)   
    for letter in Alphabet:    
        dicoAlphabet[letter] = float( list_image_cat.count(letter) )/nbr_chr
    return  [dicoAlphabet,nbr_chr]


def dict_freq_numbers_2(list_image_rl_AC,alphabet_cat_AC):
    # Image_cat and Alphabet have to be lists 
    nbr_chr = 0 
    dicoAlphabet= {}
    for letter_i in alphabet_cat_AC:
       for letter_j in alphabet_cat_AC:
           nbr_chr += list_image_rl_AC.count([letter_i,letter_j])  
    for letter_i in alphabet_cat_AC:    
        for letter_j in alphabet_cat_AC:
            dicoAlphabet[tuple([letter_i,letter_j])] = float(  list_image_rl_AC.count([letter_i,letter_j])   )/nbr_chr

    return  [dicoAlphabet,nbr_chr]


# Build the Huffman tree      
def build_huffman_tree(letter_count):
    """ recieves dictionary with char:count entries
        generates a LIST structure representing
        the binary Huffman encoding tree"""
    queue = [(x, px) for x,px in letter_count.items()]
    while len(queue) > 1:
    # combine two smallest elements
        a, pa = extract_min(queue)   # smallest in queue
        b, pb = extract_min(queue)   # next smallest
        chars = [a,b]
        weight = pa+pb # combined weight
        queue.append((chars,weight)) # insert new node
        #print(queue)   # to see what whole queue is
        #print()
    x, px = extract_min(queue) # only root node left 
    return x

def extract_min(queue):
    P = [px for x,px in queue]
    return queue.pop(P.index(min(P)))

def generate_code(huff_tree, prefix=""):
    """ receives a Huffman tree with embedded encoding,
        and a prefix of encodings.
        returns a dictionary where characters are
        keys and associated binary strings are values."""
    if isinstance(huff_tree, int): # a leaf
        return {huff_tree: prefix}
    else:
        lchild, rchild = huff_tree[0], huff_tree[1]
        codebook = {}

        codebook.update( generate_code(lchild, prefix+'0'))
        codebook.update( generate_code(rchild, prefix+'1'))
        return codebook
    
 # Build the two dimensional Huffman code      
def generate_code_2(huff_tree, prefix=""):
    """ receives a Huffman tree with embedded encoding,
        and a prefix of encodings.
        returns a dictionary where characters are
        keys and associated binary strings are values."""
    if isinstance(huff_tree[0], int): # a leaf
        return {huff_tree: prefix}
    else:
        lchild, rchild = huff_tree[0], huff_tree[1]
        codebook = {}

        codebook.update( generate_code_2(lchild, prefix+'0'))
        codebook.update( generate_code_2(rchild, prefix+'1'))
        return codebook
    
def compress(text, encoding_dict):
  """ compress text using encoding dictionary """
  # assert isinstance(text, int)
  return "".join(encoding_dict[ch] for ch in text)
   
 # Compress 2 dimensional data usinf Huffman 
def compress_2(text, encoding_dict):
  """ compress text using encoding dictionary """
  # assert isinstance(text, int)
  return "".join(encoding_dict[tuple(text[i])] for i in range(0,len(text)))


def build_decoding_dict(encoding_dict):
   """build the "reverse" of encoding dictionary"""
   return {y:x for (x,y) in encoding_dict.items()}
  # return {y:x for x,y in encoding_dict.items()} # OK too

def decompress(bits, decoding_dict):
   prefix = ""
   result = []
   for bit in bits:
      prefix += bit
      if prefix in decoding_dict:
          result.append(decoding_dict[prefix])
          prefix = ""
   assert prefix == "" # must finish last codeword
   return result   # converts list of chars to a string

def computeEntropy(probabilities) : 
    sum = 0
    for i in probabilities :
        if probabilities[i] != 0 :
            sum +=  - probabilities[i]*np.log2(probabilities[i])/np.log(2.0)
    return sum 