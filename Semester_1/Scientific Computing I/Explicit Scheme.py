import numpy as np
import matplotlib.pyplot as plt
from math import *

a=0
b=1
N=19
mu=1
uleft=0
uright=0
dx=(b-a)/(N+1)
t_max = 0.5
cf1 = 0.9
#dt = cf1*dx**2/(2*mu)
dt = 0.0001
t=0

x = np.arange(a,b,dx)
x = np.delete(x,[0])



# Different Input Signals

def Parabolic(x):
    U=[]
    for i in x:
        U.append(4*i*(i-1))
    return U

def Gaussian(x):
    U=[]
    for i in x:
        U.append(exp(-500*(i-0.5)**2))
    return U

def Heaviside(x):
    U=[]
    for i in x:
        if i>=(1/3) and i<=(2/3):
            U.append(1)
        else:
            U.append(0)
    return U

def High_freq(x):
    U=[]
    for i in x:
        U.append(sin(16*pi*i))
    return U

def Low_freq(x,b):
    U=[]
    for i in x:
        U.append(sin(2*pi*i/b))
    return U

def High_Low(x):
    U=[]
    for i in x:
        U.append(sin(4*pi*i) + 0.2*sin(40*pi*i))
    return U

U=Parabolic(x)
Ut = np.copy(U)

while t<t_max:
    t=t+dt
    for i in range(1,len(U)-1):
        Ut[i] = U[i] + dt*mu*0.25*(U[i+1]-2*U[i]+U[i-1])/dx**2
    U = np.copy(Ut)
    #plt.plot(x,U)

print(U[10])

# Non-zero Source Term

t=0
U=Parabolic(x)
Ut = np.copy(U)

def f(x,t):
    return 4*t*sin(pi*x)

def f_exact(x,t):
    return ((x*(x-1))**2)/(1+10*t)

t=0
Source_term=[]
for i in x:
    t=t+dt
    Source_term.append(f(i,t))

while t<t_max:
    t=t+dt
    for i in range(1,len(U)-1):
        Ut[i] = U[i] + dt*(Source_term[i] + mu*(U[i+1] - 2*U[i] + U[i-1])/dx**2)
    U = np.copy(Ut)
    plt.plot(x,U)

#print(U[10])

t=0
U_exact=[]
for i in x:
    t=t+dt
    U_exact.append(f_exact(i,t))

#plt.plot(x,U_exact)


# Error Computation

error=[]
for i in range(N):
    error.append(abs(U[i]-U_exact[i]))

#plt.plot(x,error)
#print(max(error))