PRO showimg, c, windownum, BOTTOM=BOTTOM 

xdim = n_elements(c(*,0))
ydim = n_elements(c(0,*))

CASE N_PARAMS() OF
  1: windownum = 0
  2: windownum = windownum
  else:         
ENDCASE

   b=c
IF(N_ELEMENTS(BOTTOM) GT 0) THEN BEGIN
   bidx=where(c le BOTTOM,nbidx)
   IF (nbidx gt 0 and nbidx lt n_elements(c)) then b(bidx)=min(c(where(c gt bottom)))
END
window, windownum, xs=xdim, ys=ydim
tvscl, b
end

