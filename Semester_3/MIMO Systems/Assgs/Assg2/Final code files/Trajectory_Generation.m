

%% Creating a structure for the system's physical properties
drone.md = 1;
drone.mc = 1;
drone.l = 1;
drone.ld = 1;
drone.J = 1;
drone.Cd = 0.01;
drone.g = 10;
maxThrust= 100;
%% MPC handler config
% MPC handler init
nx = 8; % dimension of state vector
ny = 8; % dimension of output vector
nu = 2; % dimension of input vector
nlobj = nlmpc(nx,ny,nu); % create nonlinear MPC solver handle

% MPC basic control parameters
nlobj.Ts = 1/50; % sampling time equal to usual servo frequency
nlobj.PredictionHorizon = 2/(1/50); % how many steps to look ahead (2 sec)
nlobj.ControlHorizon = 2/(1/50); % entire trajectory needs to be controlled

% this is where we link the MPC handler to our dynamics model
nlobj.Model.StateFcn = "drone2d_dynamics";
nlobj.Model.OutputFcn = "drone2d_output";
nlobj.Model.IsContinuousTime = true;

% setting the number of additional parameters of solver.
% we only use the DRONE structure as additional argument!
nlobj.Model.NumberOfParameters = 1;

% setting optimization solver options here!
nlobj.Optimization.SolverOptions.Algorithm = 'active-set';
nlobj.Optimization.SolverOptions.Display = 'iter';
nlobj.Optimization.UseSuboptimalSolution = true;
nlobj.Optimization.SolverOptions.MaxIterations = 8;

% this set the equality constraints of the MPC problem:
%  - in our case, we want all the state vectors to be 0 except for the 
%    horizontal and vertical positions
nlobj.Optimization.CustomEqConFcn = @(X,U,data,params) [X(end,1)-4 X(end,2)-1 X(end,3:end)]';

% this set the inequality constraints of the MPC problem:
%  - in our case, we want the rocket to stay above ground all times during
%  the entire flight phase.
nlobj.Optimization.CustomIneqConFcn = @(X,U,e,data,params) [X(1:end,2)];

% cost function options! I didn't play with it much, since I was happy
% having any trajectory that worked. in practice, you should tune these
% values to obtain the best and safest trajectory!
nlobj.Weights.OutputVariables = [10 10 0 0 0 0 0 0];
nlobj.Weights.ManipulatedVariables = [1 1];
nlobj.Weights.ManipulatedVariablesRate = [1 1];

% Input Constraints!
nlobj.ManipulatedVariables = struct('Min',{0;0},'Max',{maxThrust;maxThrust},RateMin={-1;-1},RateMax={3;3});

% initial conditions for the simulation
x0 = zeros(8,1);
x0(2) = 1; % assume we are 1 meter above ground
u0 = 0.5*(drone.mc+drone.md)*drone.g*ones(nu,1);

% this function runs some sanity checks for us
validateFcns(nlobj,x0,u0,[],{drone});

% in the following, we set up an initial guess for this problem since it is
% a difficult problem to converge to a solution.
nloptions = nlmpcmoveopt;
nloptions.Parameters = {drone};
load InitialGuess_drone.mat;
nloptions.MV0 = InitialGuess_drone.u;
nloptions.X0 = InitialGuess_drone.x;

% solve the problem!!!
[~,~,info] = nlmpcmove(nlobj,x0,u0,[],[],nloptions);

%% extract the solution data and animate the trajectory

t = info.Topt';
r = [info.Xopt(:,1)'; info.Xopt(:,2)'];
the = info.Xopt(:,5)';
gam = info.Xopt(:,7)';

drone2d_animate(drone, t, r, the, gam);
