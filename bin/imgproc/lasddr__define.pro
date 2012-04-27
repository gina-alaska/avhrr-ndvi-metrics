PRO LASDDR__Define

LASDDR = {LASDDR, $
          Rec1Header: bytarr(32), $
          SysType: bytarr(12), $           ;Computer system
          ProjUnit: bytarr(12), $          ;Projection Units ?
          Last_Used_Date: bytarr(12), $    ;Last Modified Date
          Last_Used_Time: bytarr(11), $    ;Last Modified Time
          nl: 0L, $                       ;Number of Lines
          ns: 0L, $                       ;Number of Samples
          nb: 0L, $                       ;Number of Bands
          dt: 1L, $                       ;Data Type
          Master_Line: 0L, $
          Master_Sample: 0L, $
          Valid: lonarr(8), $
          ProjCode: 0L, $                 ;LAS Projection Code
          ZoneCode: 0L, $                 ;Projection Zone Code
          Ellipsoid: 0L, $                ;LAS "Datum" Ellipsoid Code
          Spare: 0L, $                    ;Spare integer value for future use

          Rec2Header: bytarr(32), $
          ProjCoef: dblarr(15), $          ;LAS Projection Coefficients
          UL: dblarr(2), $                 ;Upper Left Coordinates (Lat,Lon)
          LL: dblarr(2), $                 ;Lower Left Coordinates (Lat,Lon)
          UR: dblarr(2), $                 ;Upper Right Coordinates (Lat,Lon)
          LR: dblarr(2), $                 ;Lower Right Coordinates (Lat,Lon)
          ProjDist: dblarr(2), $           ;Projection Distance
          Increment: dblarr(2) $           ;Projection Increment
         }
END
