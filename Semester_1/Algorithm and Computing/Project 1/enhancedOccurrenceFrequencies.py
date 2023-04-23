# File opener

def readText(filepath):
    infile = open(filepath)
    text = infile.read()
    infile.close()
    return text.lower()

# Punctuation remover

def cleaner(text):
    for item in text:
        if not item.isalpha():
            text = text.replace(item,"")
    return text

# Frequency Computer

def frequency_computer(text):
    my_dict = {'a':0,'b':0,'c':0,'d':0,'e':0,'f':0,'g':0,'h':0,'i':0,'j':0,'k':0,'l':0,'m':0,'n':0,'o':0,'p':0,'q':0,'r':0,'s':0,'t':0,'u':0,'v':0,'w':0,'x':0,'y':0,'z':0}
    for letter in text:
        my_dict[letter] += 1/len(text)
    return my_dict

# English function calls

English_Text = readText('data/wutheringHeights.txt')
English_Text = cleaner(English_Text)
englishOF = frequency_computer(English_Text)
print(englishOF)

# French function calls

French_Text = readText('data/MadameBovary.txt')
French_Text = cleaner(French_Text)
frenchOF = frequency_computer(French_Text)
print(frenchOF)

# Spanish function calls

Spanish_Text = readText('data/donQuijote.txt')
Spanish_Text = cleaner(Spanish_Text)
spanishOF = frequency_computer(Spanish_Text)
print(spanishOF)

# German function calls

German_Text = readText('data/kritikDerReinenVernunft.txt')
German_Text = cleaner(German_Text)
germanOF = frequency_computer(German_Text)
print(germanOF)


# Kullback-Leibler (KL) Divergence Computation

def KLD(P,Q):
    from math import log,fabs
    
    Div_PQ = 0
    
    for i,j in zip(P,Q):
        if i == 0 or j == 0:
            continue
        Div_PQ += i*log(i/j,2)
    
    Div_QP = 0
    
    for i,j in zip(Q,P):
        if i == 0 or j == 0:
            continue
        Div_QP += i*log(i/j,2)
    
    return fabs(((Div_PQ + Div_QP)/2))

print('KL Divergences - ')
print(f'English-French = {KLD(englishOF.values(),frenchOF.values())}')
print(f'English-Spanish = {KLD(englishOF.values(),spanishOF.values())}')
print(f'English-German = {KLD(englishOF.values(),germanOF.values())}')
print(f'French-Spanish = {KLD(frenchOF.values(),spanishOF.values())}')
print(f'French-German = {KLD(frenchOF.values(),germanOF.values())}')
print(f'Spanish-German = {KLD(spanishOF.values(),germanOF.values())}')


# Language Detector

def lang_det(testfile):
    testfileOF = frequency_computer(testfile)
    lang = ''
    Div_Eng = KLD(testfileOF.values(),englishOF.values())
    Div_Fre = KLD(testfileOF.values(),frenchOF.values())
    Div_Spa = KLD(testfileOF.values(),spanishOF.values())
    Div_Ger = KLD(testfileOF.values(),germanOF.values())
    
    if Div_Eng == min(Div_Eng,Div_Fre,Div_Spa,Div_Ger):
        lang = 'English'
        return lang
    elif Div_Fre == min(Div_Eng,Div_Fre,Div_Spa,Div_Ger):
        lang = 'French'
        return lang
    elif Div_Spa == min(Div_Eng,Div_Fre,Div_Spa,Div_Ger):
        lang = 'Spanish'
        return lang
    else:
        lang = 'German'
        return lang


# Accuracy of the Language Detector

def Acc_det(text,n):
    l = len(text)
    parts = []
    for i in range(0,l-n+1):
        parts.append(text[i:i+n])
    
    detector_results = []
    for i in parts:
        if lang_det(i) == 'English':
            detector_results.append(1)
        else:
            detector_results.append(0)
    return detector_results.count(1)/(l-n+1)*(100)

passage = readText('data/austen-emma-excerpt.txt')
passage = cleaner(passage)
lengths = []
probabilities = []

for length in range(2,len(passage)+1):
    probabilities.append(Acc_det(passage,length))
    lengths.append(length)

from matplotlib.pyplot import plot

plot(lengths,probabilities)