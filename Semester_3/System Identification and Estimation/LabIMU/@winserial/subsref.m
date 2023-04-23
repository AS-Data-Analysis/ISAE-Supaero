function value=subsref(obj,subscript)
%SUBSREF subsref for a WINSERIAL object

if length(subscript) > 1
  error('WINSERIAL objects only support one level of subscripting.');
end

switch subscript.type
  case '.'
    param = subscript.subs;
    value = get(obj, param);
  otherwise
    error('WINSERIAL objects only support structure subscripting.')
end
