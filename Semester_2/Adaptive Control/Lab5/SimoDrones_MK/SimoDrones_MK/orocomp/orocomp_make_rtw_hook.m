function orocomp_make_rtw_hook(hookMethod,modelName,rtwroot,templateMakefile,buildOpts,buildArgs) %#ok<INUSD>
% OROCOMP_MAKE_RTW_HOOK - This is the standard ERT hook file for the build
% process (make_rtw), and implements automatic configuration of the
% models configuration parameters.
%
% This hook file (i.e., file that implements various codegen callbacks) is
% called for system target file ert.tlc.  The file leverages
% strategic points of the build process.  A brief synopsis of the callback
% API is as follows:
%
% ert_make_rtw_hook(hookMethod, modelName, rtwroot, templateMakefile, buildOpts, buildArgs)
%
% hookMethod:
%   Specifies the stage of the build process.
%   Possible values are entry, before_tlc, after_tlc, before_make, after_make and exit, etc.
%
% modelName:
%   Name of model.  Valid for all stages.
%
% rtwroot:
%   Reserved.
%
% templateMakefile:
%   Name of template makefile.  Valid for stages 'before_make' and 'exit'.
%
% buildOpts:
%   Valid for stages 'before_make' and 'exit', a MATLAB structure
%   containing fields
%
%   modules:
%     Char array specifying list of generated C files: model.c, model_data.c,
%     etc.
%
%   codeFormat:
%     Char array containing code format: 'RealTime', 'RealTimeMalloc',
%     'Embedded-C', and 'S-Function'
%
%   noninlinedSFcns:
%     Cell array specifying list of non-inlined S-Functions.
%
%   compilerEnvVal:
%     String specifying compiler environment variable value, e.g.,
%     D:\Applications\Microsoft Visual
%
% buildArgs:
%   Char array containing the argument to make_rtw.  When pressing the build
%   button through the Configuration Parameter Dialog, buildArgs is taken
%   verbatim from whatever follows make_rtw in the make command edit field.
%
% You are encouraged to add other configuration options, and extend the
% various callbacks to fully integrate ERT into your environment.

% Copyright 1996-2010 The MathWorks, Inc.
%-------------------------------------------------------------------------------
% (c)Institut Superieur de l'Aeronautique et de l'Espace
%    Laurent Alloza (laurent.alloza(a)isae.fr)
%    21-Sep-2015
%-------------------------------------------------------------------------------

switch hookMethod
  case 'error'
    % Called if an error occurs anywhere during the build.  If no error occurs
    % during the build, then this hook will not be called.  Valid arguments
    % at this stage are hookMethod and modelName. This enables cleaning up
    % any static or global data used by this hook file.
    msg = DAStudio.message('RTW:makertw:buildAborted', modelName);
    disp(msg);
  case 'entry'
    % Called at start of code generation process (before anything happens.)
    % Valid arguments at this stage are hookMethod, modelName, and buildArgs.
    msg = DAStudio.message('RTW:makertw:enterRTWBuild', modelName);
    disp(msg);
    
  case 'before_tlc'
    % Called just prior to invoking TLC Compiler (actual code generation.)
    % Valid arguments at this stage are hookMethod, modelName, and buildArgs
    
  case 'after_tlc'
    % Called just after to invoking TLC Compiler (actual code generation.)
    % Valid arguments at this stage are hookMethod, modelName, and buildArgs
    %-------------------------------------------------------------------------------
    % Generation of CMakeLists.txt
    %-------------------------------------------------------------------------------
    disp('### Generating CMakeLists.txt...');
    folderstruct = RTW.getBuildDir(gcs);
    CMakeLists = fullfile(folderstruct.BuildDirectory,'CMakeLists.txt');
    fid = fopen(CMakeLists, 'w');
    fprintf(fid, '# OROCOS component generated from Simulink Model\n');
    fprintf(fid, '# Date  : %s\n', datestr(now,1));
    fprintf(fid, '# Model : %s\n\n', gcs);
    fprintf(fid, 'cmake_minimum_required(VERSION 2.6.3)\n\n');
    fprintf(fid, 'find_package(IsaeComponent REQUIRED)\n\n');
    fprintf(fid, 'include(${ISAE_COMPONENTS_HELPER}/isae.cmake)\n\n');
    fprintf(fid, 'isae_orocos_comp(%s TYPE_DEPENDS common command sensor DEPENDS)\n',gcs);
    fclose(fid);
    
  case 'before_make'
    % Called after code generation is complete, and just prior to kicking
    % off make process (assuming code generation only is not selected.)
    % All arguments are valid at this stage.
    
  case 'after_make'
    % Called after make process is complete. All arguments are valid at this stage.
    
  case 'exit'
    % Called at the end of the build process.  All arguments are valid at this stage.
    msg = DAStudio.message('RTW:makertw:exitRTWGenCodeOnly',modelName);
    disp(msg);
    export_sources(modelName);
end
end

function export_sources(modelName)
%-------------------------------------------------------------------------------
% Get build informations
%-------------------------------------------------------------------------------
folderstruct = RTW.getBuildDir(modelName);
load(fullfile(folderstruct.BuildDirectory,'buildInfo.mat'),'buildInfo');
CMakeLists = fullfile(folderstruct.BuildDirectory,'CMakeLists.txt');
componentname = sprintf('ORO_COMP_%s',modelName);
srcfiles      = [getSourceFiles(buildInfo, true, true),getIncludeFiles(buildInfo, true, true)];
srcfilesnames = [getSourceFiles(buildInfo, false, false),getIncludeFiles(buildInfo, false, false)];
allfiles = {CMakeLists};
excludedfiles = {...
  'rt_cppclass_main.cpp','ert_main.cpp','rtmodel.h', ...
  'frame.h','attitude.h','Pose.h','pos_vel.h','twist.h', ...
  'attitude_target.h','actuator_control_target.h', ...
  'battery.h','gps_frame.h','gps_pos_vel.h','imu.h' ...
  };
for i = 1:length(srcfiles)
  % add file to allfifles if not in excludedfiles list
  if not(sum(strcmp(excludedfiles,srcfilesnames{i})))
    allfiles{end+1}=srcfiles{i}; %#ok<AGROW>
  end
end
%-------------------------------------------------------------------------------
% Copy generated files to a local folder
%-------------------------------------------------------------------------------
pathprefix = get_param(modelName,'LocalPATH');
if not(isempty(pathprefix)),
  if not(isdir(pathprefix)),
    fprintf('Invalid local path prefix %s\n',pathprefix);
    return;
  end
  destdir = fullfile(pathprefix,componentname);
  fprintf('### Copying component files in %s\n',destdir);
  if isdir(destdir),
    rmdir(destdir,'s');
  end
  mkdir(destdir);
  for i = 1:length(allfiles)
    if not(copyfile(allfiles{i},destdir)),
      fprintf('Failed to copy file in %s\n',destdir);
    end
  end
end
%-------------------------------------------------------------------------------
% Upload files to target (if option checked)
%-------------------------------------------------------------------------------
UploadAfterGenerate = strcmpi(get_param(modelName,'UploadAfterGenerate'),'on');
if not(UploadAfterGenerate),return;end	% Nothing to do

pathprefix = get_param(modelName,'TargetPATH');
ip         = get_param(modelName,'TargetIP');
username   = get_param(modelName,'TargetUSERNAME');
password   = get_param(modelName,'TargetPASSWD');
destdir = [pathprefix '/' componentname];
tgt = ssh2(ip);
tgt.username = username;
tgt.password = password;
tgt.timeout  = 3;
tgt.scpmode  = 640;
tgt.open();
cmd = sprintf('mkdir -p %s',destdir);
tgt.execCommand(cmd);
fprintf('### Uploading component files in %s.\n',destdir);
tgt.scpput('',allfiles,destdir);
tgt.close();
end
