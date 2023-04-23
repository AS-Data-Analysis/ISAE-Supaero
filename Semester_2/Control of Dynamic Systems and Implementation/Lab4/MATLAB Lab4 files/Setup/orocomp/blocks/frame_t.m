classdef frame_t < Simulink.IntEnumType
  % frame_t enumeration definition.
  
  %-------------------------------------------------------------------------------
  % (c)Institut Superieur de l'Aeronautique et de l'Espace
  %    Laurent Alloza (laurent.alloza(a)isae.fr)
  %    12-Oct-2015
  %-------------------------------------------------------------------------------
  enumeration
    GLOBAL_FRAME(0)
    LOCAL_NED(1)
    LOCAL_ENU(2)
    BODY_NED(3)
    BODY_ENU(4)
  end
  methods (Static)
    function retVal = getDefaultValue()
      retVal = frame_t.GLOBAL_FRAME;
    end
		function retVal = getDescription()
			retVal = 'Frame Types';
		end
		function retVal = getDataScope()
			retVal = 'Exported'; 
		end
		function retVal = getHeaderFile()
			retVal = 'frame.h'; 
		end
  end
end

