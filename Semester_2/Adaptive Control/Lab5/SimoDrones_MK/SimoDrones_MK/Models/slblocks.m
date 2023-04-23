function blkStruct = slblocks
%SLBLOCKS Defines the block library for a specific Toolbox or Blockset.

%-------------------------------------------------------------------------------
% (c)Institut Superieur de l'Aeronautique et de l'Espace
%    francois Defay
%    03-11-2015
%-------------------------------------------------------------------------------

% Information for Simulink Library Browser
Browser.Library = 'lib_isae_drones';
Browser.Name    = 'ISAE drones';
Browser.IsFlat  = 0; % Is this library "flat" (i.e. no subsystems)?


blkStruct.Browser = Browser;
