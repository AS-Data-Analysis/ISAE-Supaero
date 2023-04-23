function orocomp_auto_config(hDlg, hSrc)
% OROCOMP_AUTO_CONFIG - Customize model options for Orocos Component Target
%
%-------------------------------------------------------------------------------
% (c)Institut Superieur de l'Aeronautique et de l'Espace
%    Laurent Alloza (laurent.alloza(a)isae.fr)
%    08-Oct-2015
%-------------------------------------------------------------------------------
Config = getActiveConfigSet(gcs);
newName = 'Orocos Component Configuration';
if not(strcmp(Config.Name,newName))
   % backup previous config
   oldName   = Config.Name;
   oldConfig = Config.copy;
   attachConfigSet(gcs, oldConfig, true);
   % rename current config
   Config.Name    = newName;
   oldConfig.Name = oldName;
end
%-------------------------------------------------------------------------------
% C++ Class options
%-------------------------------------------------------------------------------
slConfigUISetVal(hDlg, hSrc, 'CPPClassGenCompliant', 'on');
slConfigUISetVal(hDlg, hSrc, 'TargetLang','C++');
slConfigUISetVal(hDlg, hSrc, 'CodeInterfacePackaging','C++ class');
slConfigUISetVal(hDlg, hSrc, 'ZeroExternalMemoryAtStartup','off');
slConfigUISetVal(hDlg, hSrc, 'ExtMode', 0);
slConfigUISetVal(hDlg, hSrc, 'ParameterMemberVisibility','protected');
slConfigUISetVal(hDlg, hSrc, 'InternalMemberVisibility','protected');
slConfigUISetVal(hDlg, hSrc, 'InlineParams','on');
setClassName(RTW.getEncapsulationInterfaceSpecification(gcs), [gcs 'ModelClass']);
%-------------------------------------------------------------------------------
% Solver options
%-------------------------------------------------------------------------------
slConfigUISetVal(hDlg, hSrc, 'SolverType', 'Fixed-step');
slConfigUISetVal(hDlg, hSrc, 'SolverMode', 'SingleTasking');
slConfigUISetVal(hDlg, hSrc, 'PositivePriorityOrder','on');
%-------------------------------------------------------------------------------
% code generation options
%-------------------------------------------------------------------------------
slConfigUISetVal(hDlg, hSrc, 'GenCodeOnly','on');
slConfigUISetVal(hDlg, hSrc, 'GenerateSampleERTMain', 'on');
slConfigUISetVal(hDlg, hSrc, 'GenerateMakefile', 'off');
slConfigUISetVal(hDlg, hSrc, 'SuppressErrorStatus','on');
slConfigUISetVal(hDlg, hSrc, 'ModelReferenceCompliant', 'off');
slConfigUISetVal(hDlg, hSrc, 'MaxIdLength',63);
slConfigUISetVal(hDlg, hSrc, 'TargetLibSuffix', '.a');
%-------------------------------------------------------------------------------
disp('### Orocos Component Target.');
disp('### (c)2015 Institut Superieur de l''Aeronautique et de l''Espace');
