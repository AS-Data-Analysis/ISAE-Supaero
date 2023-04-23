function wsize = fwrite(obj, A)
% function wsize = fwrite(obj, varargin)
%FWRITE Write binary data to device.
%   FWRITE(OBJ, A) writes the data A, to the device connected to serial port object, OBJ.
%
%   Example:
%       s = winserial('COM1');
%       fopen(s);
%       fwrite(s, uint8([0 5 5 0 5 5 0]) );
%       fclose(s);
%
%   See also WINSERIAL/FOPEN, WINSERIAL/FCLOSE, WINSERIAL/FREAD
%

assert(isa(obj,'winserial') && length(obj)==1,'First input must be a 1-by-1 WINSERIAL object.');
assert(isrow(A),'Second input must be a Row vector.');

if ischar(A),
  A = uint8(A);
end
bytes = typecast(A,'uint8');
count = length(bytes);
wsize = communicate('comwrite', obj.FileID, bytes, count);
