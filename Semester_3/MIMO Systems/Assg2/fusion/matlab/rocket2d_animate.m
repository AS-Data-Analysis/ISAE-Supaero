function rocket2d_animate(rocket,t,r,theta,del)
%ROCKET2D_ANIMATE creates a video of the trajectory
%  - rocket: data structure containing rocket parameters.
%      |- in this function, we only care for rocket.h_cg, which is the
%      height of the CG. we consider, for drawing purposes, the rocket to
%      be as height as twice this value.
%  - t: time instants in R(1,N) [sec]
%  - r: position (X,Y) in R(2,N) [m]: *Y points up!!!
%  - theta: pitch angle in R(1,N) [rad]
%  - del: thrust angle in R(1,N) [rad]

% this flag decides if a video should be recorded or not!
PRESENTATION_MODE = true;

% as promised above!
h = 2*rocket.h_cg;

figure;

if (PRESENTATION_MODE)
    vw = VideoWriter('animation.avi');
    open(vw);
end

for id = 1:length(t)
   % drawing rocket
   dx = [-h/8; -h/8; 0; h/8; h/8; -h/8];
   dy = [0;h;1.1*h;h;0;0];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   hold on;
   % drawing nozzle
   dx = [-h/16; -h/8; h/8; h/16; -h/16];
   dy = [0;-1.1*h/8; -1.1*h/8; 0; 0];
   pr = r(:,id) + [cos(theta(1,id)+del(1,id)) -sin(theta(1,id)+del(1,id)); sin(theta(1,id)+del(1,id)) cos(theta(1,id)+del(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   % drawing exhaustion
   dx = [0;0];
   dy = [-1.1*h/8;-5*h/8];
   pr = r(:,id) + [cos(theta(1,id)+del(1,id)) -sin(theta(1,id)+del(1,id)); sin(theta(1,id)+del(1,id)) cos(theta(1,id)+del(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.--r', 'MarkerSize', 2, 'LineWidth', 2);
   % draw floor
   pFx = [-100;100];
   pFy = [0;0];
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   
   %text(-3.8,3,'MIMO Control Lectures 2021 - Leandro Lustosa');
   %text(-3.1,2.7,'Model Predictive Control Example');
   
   hold off;
   axis equal; axis([-4 1 -1 4]);
   title(sprintf('Time: %0.2f sec', t(id)));

   drawnow;
   
   if (PRESENTATION_MODE)
        writeVideo(vw,getframe);
   end
   
end

if (PRESENTATION_MODE)
    close(vw);
end

end
