FUNCTION CopyCube, File, IS, IL, SS, SL, SB, OS, OL, OB, DTYPE=DTYPE

;
;  This function extracts a sub cube from a band sequential FILE.
;  
;  IS, IL: Input number of samples, lines
;  SS, SL, SB: Starting location
;  OS, OL, OB: Output number of samples, lines, bands
;



;
; Allocate Space
;
   CASE (DTYPE) OF

     1: BEGIN
         SubCube=BytArr(OS, OL, OB)
         Line=BytArr(OS)
         DTSize=1
     END
     2: BEGIN
         SubCube=IntArr(OS, OL, OB)
         Line=IntArr(OS)
         DTSize=2
     END
     3: BEGIN
         SubCube=LonArr(OS, OL, OB)
         Line=LonArr(OS)
         DTSize=4
     END
     4: BEGIN
         SubCube=FltArr(OS, OL, OB)
         Line=FltArr(OS)
         DTSize=4
     END
     ELSE: BEGIN
         SubCube=Bytarr(OS, OL, OB)
         Line=BytArr(OS)
         DTSize=1
     END

   ENDCASE

;
; Method 1
;
;   t0=systime(1)
;   For k=0, OB-1 DO BEGIN
;      CurrentBand=SB+k
;      InBand=BandRead(File, CurrentBand, IS, IL, DTYPE=DTYPE)
;      SubCube[*,*,k]=ImgCopy(InBand, SS, SL, OS, OL)
;   END;k
;print, 'METHOD 1:', systime(1)-t0

;
; Method 2
;
   t0=systime(1)
   OpenR, LUN, File, /Get_LUN

   For k=0, OB-1 DO BEGIN
      FOR j=0, OL-1 DO BEGIN
         
         Offset=((SB+k)*(Long(IS)*IL) + (Long(SL)+j)*IS + SS)*DTSize
         Point_LUN, LUN, OffSet
         ReadU, LUN, Line
         SubCube[*, j, k]=Line
      
      END; j
   END; k
print, 'Time(CopyCube):', systime(1)-t0

   Free_LUN, LUN 

Return, SubCube
END
