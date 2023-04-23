function y = comut(u)
global usat J tol
if u(1)+J/2/usat*u(2)*abs(u(2))>tol,
    y=-usat;
elseif u(1)+J/2/usat*u(2)*abs(u(2))<-tol,
    y = usat;
else 
    y=0;
end
