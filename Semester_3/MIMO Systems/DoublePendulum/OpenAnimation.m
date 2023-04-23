
close all;

%% window layout

ROOM_SIZE = 2.4;

figure;
figId = gcf().Number;

title('Double Pendulum animation')
hold on;
axis equal;
axis([-ROOM_SIZE ROOM_SIZE -ROOM_SIZE ROOM_SIZE]);

%% pendulum parameters for this problem
L = 1;

% drawing rod
theta1 = 0;
theta2 = 0;
dx1 = [0;L*sin(theta1)];
dy1 = [0;-L*cos(theta1)];
plot(dx1, dy1, '.-k', 'MarkerSize', 2, 'LineWidth', 2, 'Tag', 'rod1');
dx2 = [L*sin(theta1);L*sin(theta1)+L*sin(theta1+theta2)];
dy2 = [-L*cos(theta1);-L*cos(theta1)-L*cos(theta1+theta2)];
plot(dx2, dy2, '.-k', 'MarkerSize', 2, 'LineWidth', 2, 'Tag', 'rod2');
% drawing pendulum ball
dx = [L*sin(theta1)];
dy = [-L*cos(theta1)];
p=plot(dx, dy, '-o', 'MarkerSize', 20, 'LineWidth', 2, 'Tag', 'ball1');
p.MarkerFaceColor = [1 0.5 0];
dx = [L*sin(theta1)+L*sin(theta1+theta2)];
dy = [-L*cos(theta1)-L*cos(theta1+theta2)];
p=plot(dx, dy, '-o', 'MarkerSize', 20, 'LineWidth', 2, 'Tag', 'ball2');
p.MarkerFaceColor = [1 0.5 0];
