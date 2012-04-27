FUNCTION  SmoothCube, Cube, bpy

;
; This function smooths a cube the hard way: one pixel at a time
;
t0=systime(1)

   cSize=Size(Cube)
   Smoothed=Make_Array(Size=cSize)

   dt=cSize[cSize[0]+1]
   nb=cSize[cSize[0]]

   mSParam={mSmoothParam}

   mSParam.PP=0.3
   mSParam.PS=1.
   mSParam.SWin=bpy
   mSParam.rwin= 5L
   mSParam.cwin= 5L
   mSParam.pwght= 1.5
   mSParam.swght= 0.5
   mSParam.vwght= 0.05
   mSParam.minval= 0L
   mSParam.maxval= 1023L

   info={mSmoothParam:mSParam, $
         dt:dt, nb:nb $
        }

   FOR i = 0, cSize[1]-1 DO BEGIN                  ; Lines
      FOR j = 0, cSize[2]-1 DO BEGIN               ; Samples

         imgWrite, cube[i,j,*], '/tmp/pixel'
         Smoothed[i,j,*]=Call_Smoother(info, i, j)

      END; i
   print, "LINE:",i
   END; j

print, "TIME(SMOOTHCUBE):", systime(1)-t0
print, "Size:", cSize
Return, Smoothed

END

