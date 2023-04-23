% This script sets up the MLC problem by building the "parameter" object
% employed during the learing process.

% For parameter definition, please refere to:
% Duriez, T., Brunton, S.L. and Noack, B.R., "Machine learning control - 
% taming nonlinear dynamics and turbulence", chapt. 2, vol. 116, 
% Springer, 2017.


global Tend dt InitCond sysOL Vd Vn Vdn

%% Editable Parameters 

        parameters.size=50;
        parameters.sensors=1;  
        parameters.controls=4;
        
        parameters.elitism=10;
        parameters.probrep=0.1;
        parameters.probmut=0.4;
        parameters.probcro=0.5;
 
        parameters.sensor_spec=0;
        parameters.sensor_prob=0.33;
        parameters.leaf_prob=0.3;
        parameters.range=10;
        parameters.precision=4;
        parameters.opsetrange=[1:3];     % set of operator [+ - x]
        parameters.formal=1;
        parameters.end_character='';
        parameters.individual_type='tree';
        
        parameters.problem_variables.Tend = Tend;
        parameters.problem_variables.dt = dt;
        parameters.problem_variables.InitCond =  InitCond;
        parameters.problem_variables.sysOL = sysOL;
        parameters.problem_variables.disturbances.Vd = Vd;
        parameters.problem_variables.disturbances.Vn = Vn;
        parameters.problem_variables.disturbances.Vdn = Vdn;


        %%  GP learing algortihm parameters 
        %  (CHANGE ONLY IF YOU KNOW WHAT YOU'RE DOING)
        
        parameters.maxdepth=15;
        parameters.maxdepthfirst=5;
        parameters.mindepth=2;
        parameters.mutmindepth=2;
        parameters.mutmaxdepth=15;
        parameters.mutsubtreemindepth=2;
        parameters.generation_method='mixed_ramped_gauss';
        parameters.gaussigma=3;
        parameters.ramp=[2:8];
        parameters.maxtries=10;
        parameters.mutation_types=1:4;


        %%  Optimization parameters



        parameters.selectionmethod='tournament';
        parameters.tournamentsize=7;
        parameters.lookforduplicates=1;
        parameters.simplify=0;
        parameters.cascade=[1 1];

        %%  Evaluator parameters 

        parameters.evaluation_method='mfile_standalone';        % available options:standalone_function, standalone_files, mfile_standalone
        parameters.evaluation_function='MLC_LQE_benchmarking_evaluator_students';
        parameters.indfile='ind.dat';
        parameters.Jfile='J.dat';
        parameters.exchangedir=fullfile(pwd,'evaluator0');
        parameters.evaluate_all=0;
        parameters.ev_again_best=1;
        parameters.ev_again_nb=5;
        parameters.ev_again_times=5;
        parameters.artificialnoise=0;
        parameters.execute_before_evaluation='';
        parameters.badvalue=10^36;
        parameters.badvalues_elim='all';                        % available options: first, none, all
        parameters.preevaluation=0;
        parameters.preev_function='';
        

       
%         parameters.problem_variables.disturbances.Vd = Vd;
%         parameters.problem_variables.disturbances.Vn = Vn;
%         parameters.problem_variables.disturbances.Vdn = Vdn;
%         parameters.problem_variables.benchmark = benchmark;
%         parameters.problem_variables.model = model;
        

        %% MLC internal setup parameters 
        
        parameters.save=1;
        parameters.saveincomplete=1;
        parameters.verbose=2;
        parameters.fgen=250; 
        parameters.show_best=1;
        parameters.savedir=fullfile(pwd,'save_GP');










