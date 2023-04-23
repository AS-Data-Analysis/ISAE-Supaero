function [water_level] = chardonnay_animate(chardonnay,t,r,theta,gamma)
%CHARDONNAY_ANIMATE Creates an animation of trajectory and returns water
% level
%
%   INPUTS:
%     - chardonnay: structure containing drone physical parameters. In this
%     function, the relevant parameters are:
%       - chardonnay.l: pendulum lenght in m (for drawing purposes only)
%       - chardonnay.l_d: drone lenght in m (for drawing purposes only)
%     - t in R(1,N): simulation N time instants (in sec)
%     - r in R(2,N): (X,Z) positions in time (in m, Z pointing up)
%     - theta in R(1,N): drone pitch angle in rad
%     - gamma in R(1,N): pendulum angle (wrt drone) in rad
%
%    OUTPUTS: 
%      - water_level in R(1): water level at the end of simulation
%

l = chardonnay.l;
l_d = chardonnay.l_d;

ROOM_SIZE = 5;

water_level = 1.3*l;

figure;

%vw = VideoWriter('animation.avi');
%open(vw);

for id = 1:length(t)
   % drawing fuselage
   dx = [-l_d;-l_d;0;l_d;l_d];
   dy = [l_d/3;0;0;0;l_d/3];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   hold on;
   % drawing left propeller
   dx = [-1.4*l_d;-0.6*l_d];
   dy = [l_d/3;l_d/3];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   % drawing right propeller
   dx = [1.4*l_d;0.6*l_d];
   dy = [l_d/3;l_d/3];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   % drawing cup support
   dx = [0;-l*sin(gamma(id))];
   dy = [0;l*cos(gamma(id))];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   dx = [-l*sin(gamma(id));-l*sin(gamma(id))-l/3*cos(gamma(id))];
   dy = [l*cos(gamma(id));l*cos(gamma(id))-l/3*sin(gamma(id))];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   dx = [-l*sin(gamma(id));-l*sin(gamma(id))+l/3*cos(gamma(id))];
   dy = [l*cos(gamma(id));l*cos(gamma(id))+l/3*sin(gamma(id))];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   % drawing cup
   dx = [-1.1*l*sin(gamma(id)); -1.1*l*sin(gamma(id))+l/3*cos(gamma(id)); -1.1*l*sin(gamma(id))+l/3*cos(gamma(id))-1.3*l*sin(gamma(id))];
   dy = [1.1*l*cos(gamma(id)); 1.1*l*cos(gamma(id))+l/3*sin(gamma(id)); 1.1*l*cos(gamma(id))+l/3*sin(gamma(id))+1.3*l*cos(gamma(id))];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   cup_right_y = pr(2,3);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   dx = [-1.1*l*sin(gamma(id)); -1.1*l*sin(gamma(id))-l/3*cos(gamma(id)); -1.1*l*sin(gamma(id))-l/3*cos(gamma(id))-1.3*l*sin(gamma(id))];
   dy = [1.1*l*cos(gamma(id)); 1.1*l*cos(gamma(id))-l/3*sin(gamma(id)); 1.1*l*cos(gamma(id))-l/3*sin(gamma(id))+1.3*l*cos(gamma(id))];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   cup_left_y = pr(2,3);
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   % draw water
   dx = [-1.1*l*sin(gamma(id))+l/3*cos(gamma(id))-water_level*sin(gamma(id)); -1.1*l*sin(gamma(id))-l/3*cos(gamma(id))-water_level*sin(gamma(id)) ];
   dy = [1.1*l*cos(gamma(id))+l/3*sin(gamma(id))+water_level*cos(gamma(id)) ; 1.1*l*cos(gamma(id))-l/3*sin(gamma(id))+water_level*cos(gamma(id))  ];
   pr = r(:,id) + [cos(theta(1,id)) -sin(theta(1,id)); sin(theta(1,id)) cos(theta(1,id))]*[dx';dy'];
   pFx = pr(1,:);
   pFy = pr(2,:);
   pFx(1) = pFx(1) + l/3*tan(gamma(id)+theta(id))*sin(gamma(id)+theta(id));
   pFy(1) = pFy(1) - l/3*sin(gamma(id)+theta(id));   % right spot!!!
   pFx(2) = pFx(2) - l/3*tan(gamma(id)+theta(id))*sin(gamma(id)+theta(id));
   pFy(2) = pFy(2) + l/3*sin(gamma(id)+theta(id));   % left spot!!!
   if ( pFy(2) > cup_left_y )
       dy = pFy(2) - cup_left_y;
       water_level = water_level-dy/cos(gamma(id)+theta(id));
   end
   if ( pFy(1) > cup_right_y )
       dy = pFy(2) - cup_right_y;
       water_level = water_level-dy/cos(gamma(id)+theta(id));
   end
   plot(pFx, pFy, '.-k', 'MarkerSize', 2, 'LineWidth', 2);
   
   %text(-4.5,-3,'MIMO Control Lectures 2021 - Leandro Lustosa');
   %text(-3.5,-3.5,'Model Predictive Control Example');
   
   hold off;
   axis equal; axis([-ROOM_SIZE ROOM_SIZE -ROOM_SIZE ROOM_SIZE]);
   title(sprintf('Time: %0.2f sec', t(id)));

   drawnow;
   
   %writeVideo(vw,getframe);
   
end

water_level = (water_level/1.3*l)*100;
%close(vw);

end
