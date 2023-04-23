% PArameter of thje mass Drop

switch missiontype
    case 'unloaded'
        mass  =  0;
    case '200g'
        mass =  0.207;
    case '400g'
        mass =  0.407;
end
switch noise
    case 'on'
        noisetrigger =  1;
    case 'off'
        noisetrigger =  0;
end

% Inertia  of the payload  in UAV axis
I=1/6*mass*(0.05^2)*eye(3);
%Steiner
Iload_UAVaxis = I + 0.4*0.1^2*[1 0 0; 0 1 0; 0 0 0];