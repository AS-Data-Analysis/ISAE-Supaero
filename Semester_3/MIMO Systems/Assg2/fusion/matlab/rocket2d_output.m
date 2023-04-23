function y = rocket2d_output(x,u,rocket)
%ROCKET2D_OUTPUT 
% All values are in S.I. units!!
%   x = [ pn pd vn vd the ome ]
%   u = [ del ]
%   y = [ pd vn vd the ome ]

pn = x(1);
pd = x(2);
vn = x(3);
vd = x(4);
the = x(5);
ome = x(6);

% in the following we disregard pn, since we don't care where we land for
% now, as long as we land (due to controllability problems!).
y = [ pd vn vd the ome ]';

end
