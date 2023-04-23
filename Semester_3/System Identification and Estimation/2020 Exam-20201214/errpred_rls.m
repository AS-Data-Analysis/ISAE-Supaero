function [err,yhat] = errpred_rls(y,u,A,B)
%errpred_rls  error and one step ahead prediction given data y,u and
%model A,B
%
%yhat(t) = -a1*y(t-1)-...-ana*y(t-na)+b1*u(t-1-d)+...bnb*u(t-nb-d)
%err(t) = y(t)-yhat(t)
%
%A = [1 a1 a2...ana] coefficients of the denominator
%B = [0 b1 b2...bnb] coefficients of the numerator
%y  vector of input data
%u  vector of output data (must be the same size of y)
%na degree of the denominator
%nb degree of the numerator
%
%Yves Briere 2020

N=length(y);
y=reshape(y,N,1);
u=reshape(u,N,1);
A=reshape(A,1,length(A));
B=reshape(B,1,length(B));
na=length(A)-1;
nb=length(B)-1;

%Initialisation of the algorithm
theta=[A(2:end) B(2:end)]';
yhat=[];
err=[];

start=max(na,nb);
for t=start:N-1
    phi=[-y(t:-1:t-na+1);u(t:-1:t-nb+1)];
    yhat=[yhat, theta'*phi];
    err=[err, y(t+1)-theta'*phi];
end
end

