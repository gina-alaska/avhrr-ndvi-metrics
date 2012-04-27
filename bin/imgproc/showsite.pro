PRO   showsite, c, windownum, title

case N_PARAMS() of
  1: windownum = 0
  2: windownum = windownum 
  3: BEGIN 
        windownum = windownum 
        title=title
     END
  else: MESSAGE, 'Wrong number of arguments'
endcase

imgdim = n_elements(c(*,0))
nbands = n_elements(c(0,*))/imgdim
window, windownum, xs=imgdim, ys=nbands*imgdim, title=title

for BIdx = 0, nbands - 1 do $
  tvscl, c(*, BIdx*imgdim:(BIdx+1)*imgdim-1), 0, BIdx*imgdim;, /ORDER

end
