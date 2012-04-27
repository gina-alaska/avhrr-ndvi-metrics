PRO   wshowsite, c, title

imgdim = n_elements(c(*,0))
nbands = n_elements(c(0,*))/imgdim
;window, windownum, xs=imgdim, ys=nbands*imgdim, title=title

for BIdx = 0, nbands - 1 do $
  tvscl, c(*, BIdx*imgdim:(BIdx+1)*imgdim-1), 0, BIdx*imgdim;, /ORDER

end
