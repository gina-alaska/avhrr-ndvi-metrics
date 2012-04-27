FUNCTION ReduceRead, file, XRed, YRed, Band, XDim, YDim, DTYPE=DType, $
         ASSOC=Assoc

;
;  This function subsamples a band of the original image (XDim, YDim)
;  to the size (XRed, YRed)
;

t0 = systime(1)


test = bandread(file, band, xdim, ydim, dtype=dtype,assoc=assoc)
data = congrid(test, xred,yred)


;IF(XRed GT XDim  OR  YRed GT YDim)  THEN MESSAGE, $
;   "ERROR: REDUCEREAD: Reduced dimensions must be LE original"
;
;XInc = XDim/XRed
;YInc = YDim/YRed
;print, XInc, YInc

;OpenR, LUN, file, /Get_LUN

;CASE (DTYPE) OF
;   1: data = bytarr(XRed, YRed)
;   2: data = intarr(XRed, YRed)
;   3: data = lonarr(XRed, YRed)
;   4: data = fltarr(XRed, YRed)
;   ELSE:
;ENDCASE


;FOR j = 0, YRed-1 DO BEGIN
;
;   FOR i = 0, XRed-1 DO BEGIN
;
;      CASE (DTYPE) OF
;
;         1: BEGIN
;               Offset = Long(Band)*XDim*YDim + $
;                         j*YInc*XDim + $
;                         i*XInc
;               ptr = assoc(LUN, bytarr(1), Offset)
;            END
;         2: BEGIN
;               Offset = (Long(Band)*XDim*YDim + $
;                         j*YInc*XDim + $
;                         i*XInc)*2
;               ptr = assoc(LUN, intarr(1), Offset)
;            END
;         3: BEGIN
;               Offset = (Long(Band)*XDim*YDim + $
;                         j*YInc*XDim + $
;                         i*XInc)*4
;               ptr = assoc(LUN, lonarr(1), Offset)
;            END
;         4: BEGIN
;               Offset = (Long(Band)*XDim*YDim + $
;                         j*YInc*XDim + $
;                         i*XInc)*4
;               ptr = assoc(LUN, fltarr(1), Offset)
;            END
;         ELSE:
;      ENDCASE
;      DATA(i,j) = ptr(0)
;   END
;END      
;

;Free_LUN, LUN


;print, "TIME(REDUCEREAD):",systime(1)-t0
return, data 
END
