function J = MLC_LQE_benchmarking_evaluator_students(ind,mlc_parameters,i,fig)

    % Obtaining parameters from MLC object.
    global m Tend sysOL dt InitCond Vd Vn Vdn

    % Plant and Simulation model data
    [A,B,C,D] = ssdata(mlc_parameters.problem_variables.sysOL);
    %simu_name = strcat('MLC_benchmarking_Model_',Matlab_Version{1,1},'_students');
    simu_name = 'MLC_LQE_benchmarking_Model_2020b_students';

    % Individual interpretation section
    
    m = ind.formal;
    
    s=tf('s');
    m=strrep(m,'S0','s');
    m=strrep(m,'S1','s');
    m=strrep(m,'S2','s');
    m=strrep(m,'S3','s');
    num1= eval(m{1,1});
    den1= eval(m{1,2});
    num2= eval(m{1,3});
    den2= eval(m{1,4});
    
    if isa(num1,'double')
        num1 = tf(num1);
    end
    if isa(den1,'double')
        den1 = tf(den1);
    end
    if isa(num2,'double')
        num2 = tf(num2);
    end
    if isa(den2,'double')
        den2 = tf(den2);
    end
    g1=(num1*s)/(den1*den2);
    g2=num2/(den1*den2);

% disp(m)

%%%%%%%%%%%%%%%%%%%%%% Individual Evaluation section
 
    if isproper(g1) && isproper(g2)
%         disp('tf is proper')
        % Encapsulation in try/catch
        try        
            [A_estMLC,B_estMLC,C_estMLC,D_estMLC] = tf2ss([g1.Numerator{1,1};g2.Numerator{1,1}],g1.Denominator{1,1});
            C_estMLC_inv = C_estMLC(1,:).^-1 ;
            idx_tmp = find( isinf( C_estMLC_inv ) );
            C_estMLC_inv(idx_tmp) = 0;
            Init_cond_estMLC = C_estMLC_inv./(size(C_estMLC_inv,2)-size(idx_tmp,2));
                
            % Cost Function Threshold
            cost_threshold = 1.5;
                
            % Simulation
            options = simset('SrcWorkspace','current');
            out = sim(simu_name,[],options);
            
            %Individual cost assignment
            if out.tout(end)== Tend             
                J = out.cost.Data(end);
%                 disp('ok')
                disp(J)
            else
    
                J = mlc_parameters.badvalue;                % Return high value if Tf is not reached.
            end
        catch err
            J = mlc_parameters.badvalue;                 % Return high value if simulation fails.
%             disp('err')        
%             disp(J)
        end
    else
        J = mlc_parameters.badvalue;
%         disp('tf is not proper')
    end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Monitoring section
        
if nargin>3                                                 % If a fourth argument is provided, plot the result           
    disp('Interpreted individal:')    
    disp(g1)
    disp(g2)
    figure(998)
    subplot(3,1,1)
    plot(out.states,'linewidth',1.2),grid, hold on,title('State Estimation, MLC solution')
    plot(out.states_est,'linewidth',1.2),
    legend('x_1','x_2','x_1 est MLC','x_2 est mlc')
    ylabel('States');grid on
    subplot(3,1,2)
    plot(out.measure,'b','linewidth',1.2)
    ylabel('Noisy Measure (y)');grid on
    subplot(3,1,3)
    plot(out.cost,'k','linewidth',1.2)
    ylabel('Cost Function (J)')
    legend('J best mlc'), xlabel('Time (sec)'),grid on
end