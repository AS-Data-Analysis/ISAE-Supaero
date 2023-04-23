% Variables to be initialized prior to execute be_bouncingball.slx
clear                                                              
                                                                        
% initial conditions                                                    
x0 = [1;1];                                                             
                 
% physical variables
gamma = 9.81;   % gravity constant
lambda = 0.9;    % restitution coefficient

% simulation horizon                                                    
T = 20;                                                                 
J = 35;                                                                 
                                                                        
% rule for jumps                                                        
% rule = 1 -> priority for jumps                                        
% rule = 2 -> priority for flows                                        
% rule = 3 -> no priority, random selection when simultaneous conditions
rule = 1;                                                               
                                                                        
%solver tolerances
RelTol = 1e-8;
MaxStep = .005;