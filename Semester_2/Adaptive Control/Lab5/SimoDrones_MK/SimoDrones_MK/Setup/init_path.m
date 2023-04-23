% Set the location of slprj to be the "work" folder of the current project:
myCacheFolder = fullfile(pwd, 'work');
if ~exist(myCacheFolder, 'dir')
    mkdir(myCacheFolder)
end
Simulink.fileGenControl('set', 'CacheFolder', myCacheFolder, ...
   'CodeGenFolder', myCacheFolder);

%% Set up paths for models, data files, and visualization
%---------------------------------------------------------% 

addpath(fullfile('Visu'));
addpath(fullfile('Images'));
addpath(fullfile('Guidance'));
addpath(fullfile('Control'));
addpath(fullfile('Results'));
addpath(fullfile('Models/Actuator'));
addpath(fullfile('IO/UDP_link'));
addpath(fullfile('orocomp'));
addpath(fullfile('orocomp/blocks'));

addpath(fullfile('Models'))
addpath(fullfile('Models','Actuators'));
addpath(fullfile('Models','Sensors'));
addpath(fullfile('Models','Drones'));
addpath(fullfile('Models','Drones','functions'));
