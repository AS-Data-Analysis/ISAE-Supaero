function K = LQR_control()

n=4;
A = zeros(n,n);
B = zeros(n,2);
epsilon = 1e-6;

x_trim = [pi ; 0 ; 0 ; 0];
u_trim = [0 ; 0];

% A matrix
for i = 1:n
dx = zeros(n,1);
dx(i) = epsilon*1j;
A(:,i) = imag(double_pendulum(x_trim+dx,u_trim))/epsilon;
end
% B matrix
for i = 1:2
du = [0; 0];
du(i) = epsilon*1j;
B(:,i) = imag(double_pendulum(x_trim,u_trim+du))/epsilon;
end

Q = eye(4);
R = eye(2);
K = lqr(A,B,Q,R)