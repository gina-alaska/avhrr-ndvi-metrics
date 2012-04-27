;FUNCTION  WindowRead, file, X,Y,Band,XWin, YWin, XDim, YDim, DTYPE=DType
FUNCTION  WindowRead, file, X,Y,nBands,XWin, YWin, XDim, YDim, DTYPE=DType

;
;  This function extracts a window from a given band of FILE
;

t0 = systime(1)
Openr, LUN, file, /Get_LUN

CASE (DTYPE) OF
   1: BEGIN 
         data = bytarr(XWin, YWin, nBands)
         tmp=bytarr(XWin)
      END
   2: BEGIN 
         data = intarr(XWin, YWin, nBands)
         tmp=intarr(XWin)
      END
   3: BEGIN 
         data = lonarr(XWin, YWin, nBands)
         tmp=lonarr(XWin)
      END
   4: BEGIN 
         data = fltarr(XWin, YWin, nBands)
         tmp=fltarr(XWin)
      END
   ELSE:
ENDCASE


for j=0l, nbands-1 do begin
band=j
for i = 0L, YWin-1 DO BEGIN

   Offset = LONG(Band)*XDim*YDim  +  XDim*(Y+i)  +  X

   CASE (DTYPE) OF
      1: Point_LUN, LUN, Offset
      2: Point_LUN, LUN, Offset*2
      3: Point_LUN, LUN, Offset*4
      4: Point_LUN, LUN, Offset*4
   ENDCASE
   readu,LUN, tmp
   data(*, i,j) = tmp

end
end
;print, "TIME(WINDOWREAD):", systime(1)-t0
Free_LUN, LUN
return, data
end

