FUNCTION BandRead, file, Band, XDim, YDim,  DTYPE=DType, ASSOC=Assoc

;
;  This function reads the specified BAND from FILE of dimensions
;  (XDim, YDim, NBands) and of data type DTYPE
;

t0 = systime(1)

OpenR, LUN, file, /Get_LUN

CASE (DTYPE) OF
  1: BEGIN
        Offset = long(Band)*XDim*YDim
        data = bytarr(XDim, YDim, /NoZero)

        if(KEYWORD_SET(ASSOC)) THEN $
           pix = assoc(LUN, bytarr(XDim, YDim), Offset) $
        ELSE BEGIN
           Point_LUN, LUN, Offset
           readu,LUN,DATA
        END
     END
  2: BEGIN
        Offset = long(Band)*XDim*YDim*2
        data = intarr(XDim, YDim, /NoZero)
        if(KEYWORD_SET(ASSOC)) THEN $
           pix = assoc(LUN, intarr(XDim, YDim), Offset) $
        ELSE BEGIN
           Point_LUN, LUN, Offset
           readu,LUN,DATA
        END
     END
  3: BEGIN
        Offset = long(Band)*XDim*YDim*4
        data = lonarr(XDim, YDim, /NoZero)
        if(KEYWORD_SET(ASSOC)) THEN $
           pix = assoc(LUN, lonarr(XDim, YDim), Offset) $
        ELSE BEGIN
           Point_LUN, LUN, Offset
           readu,LUN,DATA
        END
     END
  4: BEGIN
        Offset = long(Band)*XDim*YDim*4
        data = fltarr(XDim, YDim, /NoZero)
        if(KEYWORD_SET(ASSOC)) THEN $
           pix = assoc(LUN, fltarr(XDim, YDim), Offset) $
        ELSE BEGIN
           Point_LUN, LUN, Offset
           readu,LUN,DATA
        END
     END
  else:
ENDCASE


IF (KEYWORD_SET(ASSOC)) THEN $
data(*,*) = pix(0)

Free_LUN, LUN

;print, "TIME(BANDREAD):", systime(1)-t0
return, data
END
