FUNCTION  PixRead, file, X, Y, XDim, YDim, NBands, DTYPE = DTYPE

;
;  This function reads Pixel (X, Y) across NBands
;  from an image (XDim, YDim, NBands) in FILE.
;  
;  Start off assuming BSQ
;
t0 = systime(1)
tmp=bytarr(1)
CASE(DTYPE) OF
  1: begin
       data = bytarr(NBands, /NoZero)
       tmp = bytarr(1)
  end;1
  2: begin
       data = intarr(NBands, /NoZero)
       tmp = intarr(1)
  end;2
  3: begin
       data = lonarr(NBands, /NoZero)
       tmp = lonarr(1)
  end;3
  4: begin
       data = fltarr(NBands, /NoZero)
       tmp = fltarr(1)
  end;4
  ELSE:
ENDCASE;DTYPE

OpenR, LUN, file, /Get_LUN

time = fltarr(2,nbands)

for i = 0L, NBands-1 DO BEGIN

Offset = long(i)*long(xdim)*long(ydim)+ long(xdim)*long(y)+long(x)

   CASE(DTYPE) OF
     1: BEGIN
          Point_LUN, LUN, Offset
        END
     2: BEGIN
          Offset = Offset*2
          Point_LUN, LUN, Offset
        END
     3: BEGIN
          Offset = Offset*4
          Point_LUN, LUN, Offset
        END
     4: BEGIN
          Offset = Offset*4
          Point_LUN, LUN, Offset
        END
     else:
   ENDCASE;DTYPE

   readu, LUN, tmp
   data(i)=tmp

time(0,i) = float(i)
time(1,i) = systime(1)-t0
end

Free_LUN, LUN

print, "TIME(PIXREAD):", systime(1)-t0
;if(systime(1)-t0 gt 1) then begin
;  window,1
;  plot, time(0,*), time(1,*), /xstyle, /ystyle, psym=4, ytitle="Time, (sec)", xtitle="band"
;end
return, data
end
