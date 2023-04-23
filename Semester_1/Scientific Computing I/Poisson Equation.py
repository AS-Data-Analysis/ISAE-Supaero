import numpy as np
import matplotlib.pyplot as plt
from math import *

a=0
b=1
N=100
mu=1
uleft=0
uright=1
dx=(b-a)/(N+1)

x = np.arange(a,b,dx)
x = np.delete(x,[0])

A = np.zeros([N,N])

for i in range(N):
    for j in range(1,N):
        A[j,j-1] = -1
        A[i,i] = 2
        A[j-1,j] = -1


def f(x,dx):
    return dx*dx*(x**4 + 3*x + 1)

def f_exact(x):
    return (-x**6)/30 + (-x**3)/2 + (-x**2)/2 + (31/30)*x

B = np.array([f(i,dx) for i in x])
B[0] = B[0] + uleft
B[-1] = B[-1] + uright

u = np.linalg.solve(A,B)
u_exact = [f_exact(i) for i in x]

plt.plot(x,u,'.')
print(u[10])
#plt.plot(x,u_exact)

# Error Computation

error=[]
for i in range(N):
    error.append(abs(u[i]-u_exact[i]))

#plt.plot(x,error)
