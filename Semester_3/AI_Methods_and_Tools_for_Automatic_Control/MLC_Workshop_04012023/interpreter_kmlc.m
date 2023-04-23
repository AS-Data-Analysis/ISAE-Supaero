function y  = interpreter_kmlc(u)
global m

x = [u(1) u(2)];
y_tmp1 = u(1)*(eval(m{1,1},'x'));% 
y_tmp2 = u(2)*(eval(m{1,2},'x'));%

y = y_tmp1 + y_tmp2;
