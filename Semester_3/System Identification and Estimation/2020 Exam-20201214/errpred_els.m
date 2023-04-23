function [eps,yhat] = errpred_els( y, u, A,B,C)
%errpred_rls  error and one step ahead prediction given data y,u and
%model A,B,C
%
%yhat(t) = -a1*y(t-1)-...-ana*y(t-na)+b1*u(t-1-d)+...bnb*u(t-nb-d)...
%             +c1*err(t-1)+...cnc*err(t-nc)
%err(t) = y(t)-yhat(t)
%
%A = [1 a1 a2...ana] coefficients of the denominator
%B = [0 b1 b2...bnb] coefficients of the numerator
%C = [1 c1 c2...cnc] coefficients of the system noise polynomial
%y  vector of input data
%u  vector of output data (must be the same size of y)
%d delay
%
%Yves Briere 2020

N=length(y);
y=reshape(y,N,1);
u=reshape(u,N,1);
A=reshape(A,1,length(A));
B=reshape(B,1,length(B));
C=reshape(C,1,length(C));
na=length(A)-1;
nb=length(B)-1;
nc=length(C)-1;

%Initialisation of the algorithm
theta=[A(2:end) B(2:end) C(2:end)]';
start=max([na nb nc]);
yhat=zeros(1,N-start);
eps=zeros(1,N-start);

for t=start:N-1
    phi=[-y(t:-1:t-na+1);u(t:-1:t-nb+1);eps(t:-1:t-nc+1)'];
    yhat(t+1) = theta'*phi;
    eps(t+1) = y(t+1)-yhat(t+1);
end


end

