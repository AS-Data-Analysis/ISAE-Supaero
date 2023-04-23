%% definition of equations of motion in nonlinear form
% this goes according to BE1, in the TA notes

function xdot = chardonnay_dynamics(x,u,w,chardonnay)
% x = (pn, pd, vn, vd, the, thed, gam, gamd)
% u = (T1, T2)
% w = (w1, w2)

m_d = chardonnay.m_d;
m_c = chardonnay.m_c;
l = chardonnay.l;
l_d = chardonnay.l_d;
J = chardonnay.J;
C_D = chardonnay.C_D;
g = chardonnay.g;

x_1 = x(3);
x_2 = x(4);
x_3 = x(5);
x_4 = x(6);
x_5 = x(7);
x_6 = x(8);

u_1 = u(1);
u_2 = u(2);

w_1 = w(1);
w_2 = w(2);

Pi = [
    m_d  0  0  0  0  0  sin(x_3+x_5);
    0  m_d  0  0  0  0  cos(x_3+x_5);
    m_c 0   0  -m_c*l*cos(x_3+x_5)  0  -m_c*l*cos(x_3+x_5)  -sin(x_3+x_5);
    0 m_c 0 m_c*l*sin(x_3+x_5) 0 m_c*l*sin(x_3+x_5)  -cos(x_3+x_5);
    0 0 0 J 0 0 0;
    0 0 1 0 0 0 0;
    0 0 0 0 1 0 0 ];

h = [
    -(u_1+u_2)*sin(x_3)-C_D*(x_1-w_1);
    m_d*g-(u_1+u_2)*cos(x_3)-C_D*(x_2-w_2);
    -m_c*l*(x_4+x_6)^2*sin(x_3+x_5);
    m_c*g-m_c*l*(x_4+x_6)^2*cos(x_3+x_5);
    (u_2-u_1)*l_d;
    x_4;
    x_6 ];

fp = Pi\h;
% drop the vinculum forces in the following!
f = fp(1:6);
% add position derivatives in the following!
xdot = [x_1;x_2;f];

end
