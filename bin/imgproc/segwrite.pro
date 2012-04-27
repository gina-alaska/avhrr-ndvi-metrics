PRO SegWrite, SubCube, File, IS, IL, SS, SL, SB

;
;  This function extracts a sub cube from a band sequential FILE.
;  
;  IS, IL: Input number of samples, lines
;  SS, SL, SB: Starting location
;
DSize=Size(SubCube)
OS=DSize[1]
OL=DSize[2]
OB=DSize[3]
DTYPE=DSize[4]
;
; Allocate Space
;
   CASE (DTYPE) OF

     1: BEGIN
         Line=BytArr(OS)
         DTSize=1
     END
     2: BEGIN
         Line=IntArr(OS)
         DTSize=2
     END
     3: BEGIN
         Line=LonArr(OS)
         DTSize=4
     END
     4: BEGIN
         Line=FltArr(OS)
         DTSize=4
     END
     ELSE: BEGIN
         Line=BytArr(OS)
         DTSize=1
     END

   ENDCASE

   t0=systime(1)
   tmp=findfile(File, count=count)
   IF count eq 0 then $
   OpenW, LUN, File, /Get_LUN $
   ELSE $
   OpenU, LUN, File, /Get_LUN 

   For k=0, OB-1 DO BEGIN
      FOR j=0, OL-1 DO BEGIN
         
         Offset=((SB+k)*(Long(IS)*IL) + (Long(SL)+j)*IS + SS)*DTSize
         Point_LUN, LUN, OffSet
         Line=SubCube[*, j, k]
         WriteU, LUN, Line
      
      END; j
   END; k
;print, 'Time(SegWrite):', systime(1)-t0

   Free_LUN, LUN 

END
