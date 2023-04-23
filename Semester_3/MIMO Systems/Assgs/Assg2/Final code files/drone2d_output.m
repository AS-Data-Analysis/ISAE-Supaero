function y = drone2d_output(x,u,drone)
%DRONE2D_OUTPUT 
% All values are in S.I. units!!
%   x = [ pn pd vn vd the thed gam gamd]
%   u = [ T1 T2 ]
%   y = [ pn pd vn vd the thed gam gamd]

pn = x(1);
pd = x(2);
vn = x(3);
vd = x(4);
the = x(5);
thed = x(6);
gam = x(7);
gamd = x(8);

y = [ pn pd vn vd the thed gam gamd]';

end