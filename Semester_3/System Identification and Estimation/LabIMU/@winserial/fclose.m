function obj = fclose(obj)
%FCLOSE Close COM port.
%   OBJ = FCLOSE(OBJ) begins reading/writing the COM port associated with
%   OBJ, which is a WINSERIAL object obtained from WINSERIAL.
%
%   See also WINSERIAL/WINSERIAL, WINSERIAL/FCLOSE, , WINSERIAL/FREAD, , WINSERIAL/FWRITE.

assert(isa(obj,'winserial') && length(obj)==1,'First input must be a 1-by-1 WINSERIAL object.');
% do not allow the syntax like fclose(winserial('COM1'))
assert(not(isempty(inputname(1))),'No "WINSERIAL" object found in this work space');  

if strcmp(obj.CurrentState, 'Opened')
  communicate('comclose', obj.FileID);
  
  obj.FileID = -1;
  obj.CurrentState = 'Closed';
  assignin('caller', inputname(1), obj);
end
