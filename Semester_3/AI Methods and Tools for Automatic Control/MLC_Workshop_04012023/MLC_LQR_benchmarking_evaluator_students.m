function J = MLC_LQR_benchmarking_evaluator_students(ind,mlc_parameters,i,fig)

% Obtaining parameters from MLC object.
global m Tend Matlab_Version sysOL dt InitCond Q_MLC R_MLC

% Plant and Simulation model data
[A,B,C,D] = ssdata(mlc_parameters.problem_variables.sysOL);
% simu_name = strcat('MLC_LQR_benchmarking_Model_',Matlab_Version{1,1},'_students');
simu_name = strcat('MLC_LQR_benchmarking_Model_2020b_students');


% Individual interpretation section

m = ind.formal;

m{1,1}=strrep(m{1,1},'S0','x(1)');
m{1,1}=strrep(m{1,1},'S1','x(2)');
m{1,2}=strrep(m{1,2},'S0','x(1)');
m{1,2}=strrep(m{1,2},'S1','x(2)');

% disp(m)

%%%%%%%%%%%%%%%%%%%%%% Individual Evaluation section


try   % Encapsulation in try/catch.
    
    
        
    % Cost function Threshold
    cost_threshold = 1e3;
    % Simulation
    options = simset('SrcWorkspace','current','TimeOut',5);
    out = sim(simu_name,[],options);
    
    
    % Individual cost assignment
    if out.tout(end)== Tend
        J = out.cost.Data(end);
        disp(J)
        
    else
        
        J = mlc_parameters.badvalue;                % Return high value if Tend is not reached.
    end
catch err
    J = mlc_parameters.badvalue;                 % Return high value if simulation fails.
end





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Monitoring section
        
if nargin>3            % If a fourth argument is provided, plot the result         
           
    disp('Interpreted individal:')
    disp(m)
    figure(997)
    subplot(3,1,1)
    plot(out.states,'linewidth',1.2),grid, hold on,title('State Feedback Control, MLC solution')
    legend('x_1','x_2')
    ylabel('States');grid on
    subplot(3,1,2)
    plot(out.mlccontr,'--k','linewidth',1.2)
    ylabel('Control Action (u)');grid on
    subplot(3,1,3)
    plot(out.cost,'--k','linewidth',1.2)
    ylabel('Cost Function (J)')
    legend('J best mlc'), xlabel('Time (sec)'),grid on
    
    

end