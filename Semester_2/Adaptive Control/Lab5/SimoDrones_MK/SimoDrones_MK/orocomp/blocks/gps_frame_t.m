classdef gps_frame_t < uint8
  % gps_frame_t enumeration definition.
  
  %-------------------------------------------------------------------------------
  % (c)Institut Superieur de l'Aeronautique et de l'Espace
  %    Laurent Alloza (laurent.alloza(a)isae.fr)
  %    12-Oct-2015
  %-------------------------------------------------------------------------------
  enumeration
    LLH(0)
    ECEF(1)
    UTM(2)
    LTP(3)
  end
  methods (Static)
    function retVal = getDefaultValue()
      retVal = gps_frame_t.LLH;
    end
		function retVal = getDescription()
			retVal = 'GPS Frame Types';
		end
		function retVal = getDataScope()
			retVal = 'Exported'; 
		end
		function retVal = getHeaderFile()
			retVal = 'gps_frame.h'; 
		end
  end
end

