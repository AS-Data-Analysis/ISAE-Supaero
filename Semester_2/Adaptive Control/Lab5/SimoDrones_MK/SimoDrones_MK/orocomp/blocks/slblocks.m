function blkStruct = slblocks
%SLBLOCKS Defines the block library for a specific Toolbox or Blockset.

%-------------------------------------------------------------------------------
% (c)Institut Superieur de l'Aeronautique et de l'Espace
%    Laurent Alloza (laurent.alloza(a)isae.fr)
%    14-Sep-2015
%-------------------------------------------------------------------------------

% Information for Simulink Library Browser
Browser.Library = 'orocomplib';
Browser.Name    = 'Orocos Component Target';
Browser.IsFlat  = 1; % Is this library "flat" (i.e. no subsystems)?

blkStruct.Browser = Browser;
