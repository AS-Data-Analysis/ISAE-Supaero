function value = get(obj,param)
% GET Query WINSERIAL properties
%
%   VALUE = GET(OBJ,'PropertyName') returns the value of the specified
%   property of the WINSERIAL object OBJ.
%
%    Note: This function is a helper for SUBSREF and is not intended for
%    users.  To retrieve property values of the WINSERIAL object, use
%    structure notation.  For example:
%
%               value = obj.BaudRate;

switch lower(param)
  case 'portname'
    value = obj.PortName;
  case 'baudrate'
    value = obj.BaudRate;
  case 'parity'
    value = obj.Parity;
  case 'databits'
    value = DataBits;
  case 'stopbits'
    value = obj.StopBits;
  case 'fileid'
    value = obj.FileID;
  case 'currentstate'
    value = obj.CurrentState;
  case 'inputbuffersize'
    value = obj.InputBufferSize;
  otherwise
    error('Unrecognized parameter name ''%s''.',param)
end
return;
