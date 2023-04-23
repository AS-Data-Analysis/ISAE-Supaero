function obj = winserial(portname, varargin)
% WINSERIAL object constructor
%
%   Example:
%       s = winserial('COM1');
%       fopen(s);
%       [bytes,n] = fread(s, 15);
%       fclose(s);
%
%   See also WINSERIAL/FOPEN, WINSERIAL/FCLOSE, WINSERIAL/FREAD, WINSERIAL/FWRITE
%
assert(ispc,'This command is for the Windows version only.');
assert(nargin>=1,'You must provide a port name as the first input.(For example, "COM1")');
assert(ischar(portname),'The first input argument must be a port name.(For example, "COM1")');

obj.PortName = upper(portname);
% Global defaults
obj.BaudRate = 9600;
obj.Parity   = 'none';
obj.DataBits = 8;
obj.StopBits = 1;
obj.FileID   = -1;
obj.InputBufferSize = 512;  % Not Used Yet (communicate.c)
obj.CurrentState = 'Closed';

obj = class(obj,'winserial');
% Take care of any parameters set at the command line
obj = set(obj,varargin{:});
