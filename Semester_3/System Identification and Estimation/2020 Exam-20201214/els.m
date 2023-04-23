function [A,B,C] = els(y,u,na,nb,nc,d )
%rls Extended Least Square estimation
%
%rls( y, u, na, nb, d )returns a model [A,B,C] given measured data y and u
%
%   y      b1*z^-1+...bnb*z^-nb
%  --- = ----------------------
%   u    1+a1*z^-1+...ana*z^-na
%
%A = [1 a1 a2...ana] coefficients of the denominator
%B = [0 b1 b2...bnb] coefficients of the numerator
%C = [1 c1 c2...cnc] coefficients of the system noise polynomial
%y  vector of input data
%u  vector of output data (must be the same size of y)
%na degree of the denominator
%nb degree of the numerator
%nc order of the the system noise polynoial
%d delay
%
%Yves Briere 2020

N=length(y);
y=reshape(y,N,1);
u=reshape(u,N,1);
e=zeros(N,1);

%Initialisation of the algorithm
theta=[zeros(na,1);zeros(nb,1);zeros(nc,1)];
D=(na+nb+nc)*100000*eye(na+nb+nc);

start=max([na nb+d nc]);
for t=start:N-1
    phi=[-y(t:-1:t-na+1);u(t-d:-1:t-d-nb+1);e(t:-1:t-nc+1)];
    yhat0=theta'*phi;
    eps0=y(t+1)-yhat0;
    eps=eps0/(1+phi'*D*phi);
    e(t+1)=eps;
    theta=theta+(D*phi)*eps;
    D=D-(D*phi*phi'*D)/(1+phi'*D*phi);
end

A = [1 theta(1:na)'];
B = [0 zeros(1,d) theta(na+1:na+nb)'];
C = [1 theta(na+nb+1:end)'];

end

