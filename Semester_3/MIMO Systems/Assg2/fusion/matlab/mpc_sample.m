%% MPC Trajectory Generation example for autonomous rocket landing
% This script supports my MIMO Control course, Lecture II.

%% rocket parameters definition
% this section creates a data structure containing all rocket parameters
rocket.mass = 0.2; % in Kg
rocket.T = rocket.mass*10*1.1; % in Newtons
rocket.h_cg = 0.5; % in meters
rocket.J = 1/12*rocket.mass*(rocket.h_cg*2)^2; % using 1/12ML^2 formula

%% MPC handler config
% MPC handler init
nx = 6; % dimension of state vector
ny = 5; % dimension of output vector
nu = 1; % dimension of input vector
nlobj = nlmpc(nx,ny,nu); % create nonlinear MPC solver handle

% MPC basic control parameters
nlobj.Ts = 0.02; % sampling time equal to usual servo frequency
nlobj.PredictionHorizon = 100; % how many steps to look ahead (2 sec)
nlobj.ControlHorizon = 100; % only first 100 actions can be variable

% this is where we link the MPC handler to our dynamics model
nlobj.Model.StateFcn = "rocket2d_dynamics";
nlobj.Model.OutputFcn = "rocket2d_output";
nlobj.Model.IsContinuousTime = true;

% setting the number of additional parameters of solver.
% we only use the ROCKET structure as additional argument!
nlobj.Model.NumberOfParameters = 1;

% setting optimization solver options here!
nlobj.Optimization.SolverOptions.Algorithm = 'active-set';
nlobj.Optimization.SolverOptions.Display = 'iter';
nlobj.Optimization.UseSuboptimalSolution = true;
nlobj.Optimization.SolverOptions.MaxIterations = 8;

% this set the equality constraints of the MPC problem:
%  - in our case, we want all the state vector to be 0 except for the 
%    horizontal position. in fact, in this problem, we don't care where
%    we land (we might not choose due to lack of controllability!).
nlobj.Optimization.CustomEqConFcn = @(X,U,data,params) X(end,2:end)';

% this set the inequality constraints of the MPC problem:
%  - in our case, we want the rocket to stay above ground all times during
%  the entire flight phase.
nlobj.Optimization.CustomIneqConFcn = @(X,U,e,data,params) X(1:end-5,2);

% cost function options! I didn't play with it much, since I was happy
% having any trajectory that worked. in practice, you should tune these
% values to obtain the best and safest trajectory!
nlobj.Weights.OutputVariables = [0 0 0 0 0];
nlobj.Weights.ManipulatedVariables = 1;
nlobj.Weights.ManipulatedVariablesRate = 0;

% Input Constraints!
nlobj.ManipulatedVariables.Min = -10*pi/180;
nlobj.ManipulatedVariables.Max = +10*pi/180;
%nlobj.ManipulatedVariables.RateMin = -0.01*pi/180; % considering max speed 0.2 (sec/60deg)
%nlobj.ManipulatedVariables.RateMax = +0.01*pi/180;

% initial conditions for the simulation
x0 = zeros(6,1);
x0(2) = -1; % assume we are 1 meter above ground
x(4) = 0;
u0 = zeros(nu,1);

% this function runs some sanity checks for us
validateFcns(nlobj,x0,u0,[],{rocket});

% in the following, we set up an initial guess for this problem since it is
% a difficult problem to converge to a solution.
nloptions = nlmpcmoveopt;
nloptions.Parameters = {rocket};
load InitialGuess.mat;
nloptions.MV0 = InitialGuess.u(1:101);
nloptions.X0 = InitialGuess.x(1:101,:);

% solve the problem!!!
[~,~,info] = nlmpcmove(nlobj,x0,u0,[],[],nloptions);

%% extract the solution data and animate the trajectory

t = info.Topt';
r = [info.Xopt(:,1)'; -info.Xopt(:,2)'];
the = info.Xopt(:,5)';
del = info.MVopt(:,1)';

rocket2d_animate(rocket, t, r, the, del);
