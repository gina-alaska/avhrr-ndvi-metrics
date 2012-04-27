FUNCTION  make3band, band1, band2, band3

;
;  This function generates a single 3 band image from
;  the input images.
;
;  

ImgSize = size(band1)
NSamp = ImgSize(1)
NLine = ImgSize(2)
print, ImgSize(ImgSize(0)+1)
;
;  Figure out data type and allocate space
;
CASE (ImgSize(ImgSize(0)+1)) OF
  1: TriBand = bytarr(NSamp, NLine, 3)
  2: TriBand = intarr(NSamp, NLine, 3)
  4: TriBand = fltarr(NSamp, NLine, 3)
  else:
ENDCASE

;
;
;
CASE (N_PARAMS()) OF
  1: for i = 0,2 do TriBand(*,*,i) = Band1
  2: BEGIN
       for i = 0,1 do TriBand(*,*,i) = Band1
       TriBand(*,*,2) = Band2 
     END
  3: BEGIN
       TriBand(*,*,0) = Band1 
       TriBand(*,*,1) = Band2 
       TriBand(*,*,2) = Band3 
     END
  ELSE:
ENDCASE

RETURN, TriBand

END

