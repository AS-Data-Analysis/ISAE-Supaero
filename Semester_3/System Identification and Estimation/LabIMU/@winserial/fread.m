function [bytes,count] = fread(obj, size)
%FREAD Read binary data from device.
%
%   [BYTES,COUNT]=FREAD(OBJ,SIZE) reads at most the specified number of bytes,
%   SIZE, from the device connected to serial port object, OBJ, and
%   returns to BYTES and the number of bytes read to COUNT.
%
%   FREAD blocks until SIZE values have been received.
%
%   Example:
%       s = winserial('COM1');
%       fopen(s);
%       [bytes,n] = fread(s, 15);
%       fclose(s);
%
%   See also WINSERIAL/FOPEN, WINSERIAL/FCLOSE, WINSERIAL/FWRITE
%

assert(isa(obj,'winserial') && length(obj)==1,'First input must be a 1-by-1 WINSERIAL object.');
assert(nargout<=2,'Too many output arguments.');

% Floor the size.
% Note: The call to floor must be done after the error checking
% since floor on a string converts the string to its ascii value.
size = floor(size);

[bytes,count] = communicate('comread', obj.FileID, size);
bytes = uint8(bytes);

