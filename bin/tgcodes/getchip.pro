;=====   GETCHIP   =========================================
; This little code grabs a SIZExSIZE chip from the output of
; readlac.pro
;
; imageflag - which chip to read:
; 0 - Tallgrass, OK
; 1 -
; 2 -
; 3 - 
; 4 - 
; 5 - 
;===========================================================

FUNCTION   getchip, c,imageflag, band,size

xmin = imageflag*size
xmax = xmin + (size-1) 

return, c(xmin:xmax,0:(size-1),band)
end 

