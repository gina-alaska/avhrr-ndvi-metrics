FUNCTION yx2latlon, y, x, ProjCode, ProjParm

CASE ProjCode OF:


   11: BEGIN    			;Lamber Equal Area Azimuthal
   END; 11

   ELSE:

ENDCASE
RETURN, {Lon:Lon, Lat:Lat)
END
