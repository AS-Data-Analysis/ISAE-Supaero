function obj=subsasgn(obj,subscript,value)
%SUBSASGN subsasgn for a WINSERIAL object

if length(subscript) > 1
  error('WINSERIAL objects only support one level of subscripting.')
end

switch subscript.type
  case '.'
    param = subscript.subs;
    if strcmpi(param, 'portname')
      error('An object''s ''PortName'' property is read only.')
    elseif strcmpi(param, 'currentstate')
      error('An object''s ''CurrentState'' property is read only.')
    elseif strcmpi(param, 'fileid')
      error('An object''s ''FileID'' property is read only.')
    end
    obj = set(obj, param, value);
  otherwise
    error('WINSERIAL objects only support structure subscripting.')
end
