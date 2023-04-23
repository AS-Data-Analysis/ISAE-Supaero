function obj = fopen(obj)
%OPEN Open COM port.
%   OBJ = FOPEN(OBJ) begins reading/writing the COM port associated with
%   OBJ, which is a WINSERIAL object obtained from WINSERIAL.
%
%   See also WINSERIAL/WINSERIAL, WINSERIAL/FCLOSE, , WINSERIAL/FREAD, , WINSERIAL/FWRITE.

assert(isa(obj,'winserial') && length(obj)==1,'First input must be a 1-by-1 WINSERIAL object.');
% do not allow the syntax like fopen(winserial('COM1'))
assert(not(isempty(inputname(1))),'No "WINSERIAL" object found in this work space');  

if strcmp(obj.CurrentState, 'Closed')
  c.PortName = obj.PortName;
  c.BaudRate = obj.BaudRate;
  c.Parity   = obj.Parity;
  c.DataBits = obj.DataBits;
  c.StopBits = obj.StopBits;
  hid = communicate('comopen', c);
  obj.FileID = hid;
  obj.CurrentState = 'Opened';
  assignin('caller', inputname(1), obj);
end
