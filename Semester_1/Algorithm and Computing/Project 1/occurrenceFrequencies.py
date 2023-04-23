# -*- coding: utf-8 -*-
"""
Created on "14th September, 2021"
@author: "Akash Sharma"
"""


text = "I WENT AND CALLED, BUT GOT NO ANSWER. ON RETURNING, I WHISPERED TO CATHERINE THAT HE HAD HEARD A GOOD PART OF WHAT SHE SAID, I WAS SURE; ANDTOLD HOW I SAW HIM QUIT THE KITCHEN JUST AS SHE COMPLAINED OF HERBROTHER'S CONDUCT REGARDING HIM.  SHE JUMPED UP IN A FINE FRIGHT, FLUNG HARETON ON TO THE SETTLE, AND RAN TO SEEK FOR HER FRIEND HERSELF; NOT TAKING LEISURE TO CONSIDER WHY SHE WAS SO FLURRIED, OR HOW HER TALK WOULD HAVE AFFECTED HIM.  SHE WAS ABSENT SUCH A WHILE THAT JOSEPH PROPOSED WE SHOULD WAIT NO LONGER.  HE CUNNINGLY CONJECTURED THEY WERE STAYING AWAY IN ORDER TO AVOID HEARING HIS PROTRACTED BLESSING."
print(text)

# letters
letters ="ABCDEFGHIJKLMNOPQRSTUVWXYZ"

# PROBLEM : find the occurence frequencies of the letters of the alphabet in the following text


# We can decompose the problem as follows :
#   1- create a dictionary containing the letters with the occurrences equal to 0 
#   2- for each letter in the text, increment the corresponding entry of the dictionary
#   3- normalize the values of the dictionary in order to have frequencies (the sum is equal to 1)

frequency_distribution = {}

for letter in letters:
    frequency_distribution[letter] = 0
    for scanner in text:
        if letter == scanner:
            frequency_distribution[letter]+=1
sum = 0
for value in frequency_distribution.values():
    sum = sum + value
for key in frequency_distribution.keys():
    frequency_distribution[key] /= sum
    
print(frequency_distribution)