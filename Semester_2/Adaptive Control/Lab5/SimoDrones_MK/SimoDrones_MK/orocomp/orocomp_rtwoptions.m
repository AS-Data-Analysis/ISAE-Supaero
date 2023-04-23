function rtwoptions = orocomp_rtwoptions()
% OROCOMP_RTWOPTIONS - Add Code Generation options for Orocos Component Target
%
%-------------------------------------------------------------------------------
% (c)Institut Superieur de l'Aeronautique et de l'Espace
%    Laurent Alloza (laurent.alloza(a)isae.fr)
%    21-Sep-2015
%-------------------------------------------------------------------------------
rtwoptions = [];
o=0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ssh configuration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
o=o+1;
rtwoptions(o).prompt        = 'Orocos Component Target Configuration';
rtwoptions(o).type          = 'Category';
rtwoptions(o).enable        = 'on';
rtwoptions(o).default       = 6;   % number of items under this category
rtwoptions(o).popupstrings  = '';
rtwoptions(o).tlcvariable   = '';
rtwoptions(o).makevariable  = '';
rtwoptions(o).tooltip       = '';
rtwoptions(o).callback      = '';
o=o+1;
rtwoptions(o).prompt        = 'Local path prefix to components :';
rtwoptions(o).type          = 'Edit';
rtwoptions(o).default       = pwd;
rtwoptions(o).tlcvariable   = 'LocalPATH';
rtwoptions(o).tooltip       = 'Local parent folder of components.(Leave blank for none)';
rtwoptions(o).modelReferenceParameterCheck  = 'off';
o=o+1;
rtwoptions(o).prompt        = 'Upload to target after generation';
rtwoptions(o).type          = 'Checkbox';
rtwoptions(o).default       = 'off';
rtwoptions(o).tlcvariable   = 'UploadAfterGenerate';
rtwoptions(o).tooltip       = 'If checked, the sources are uploaded on target using ssh. ssh object is exported to workspace';
rtwoptions(o).modelReferenceParameterCheck  = 'off';
o=o+1;
rtwoptions(o).prompt        = 'Target IP';
rtwoptions(o).type          = 'Edit';
rtwoptions(o).default       = '192.168.204.130';
rtwoptions(o).tlcvariable   = 'TargetIP';
rtwoptions(o).tooltip       = 'IP or hostname used by ssh.';
rtwoptions(o).modelReferenceParameterCheck  = 'off';
o=o+1;
rtwoptions(o).prompt        = 'Username :';
rtwoptions(o).type          = 'Edit';
rtwoptions(o).default       = 'dmia';
rtwoptions(o).tlcvariable   = 'TargetUSERNAME';
rtwoptions(o).tooltip       = 'Username used by ssh.';
rtwoptions(o).modelReferenceParameterCheck  = 'off';
o=o+1;
rtwoptions(o).prompt        = 'Password :';
rtwoptions(o).type          = 'Edit';
rtwoptions(o).default       = '';
rtwoptions(o).tlcvariable   = 'TargetPASSWD';
rtwoptions(o).tooltip       = 'Password used used by ssh.';
rtwoptions(o).modelReferenceParameterCheck  = 'off';
o=o+1;
rtwoptions(o).prompt        = 'Linux path prefix to components :';
rtwoptions(o).type          = 'Edit';
rtwoptions(o).default       = '/home/dmia/dmia-orocos-components';
rtwoptions(o).tlcvariable   = 'TargetPATH';
rtwoptions(o).tooltip       = 'Linux parent folder of components.';
rtwoptions(o).modelReferenceParameterCheck  = 'off';
