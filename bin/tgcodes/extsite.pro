;===   EXTSITE =====================================
; This function extracts a single site from the data
; ordered by readlac95
;===================================================
FUNCTION   extsite, c, site, FLOAT=float 

imgdim = n_elements(c(0,*,0))
nbands = n_elements(c(0,0,*))

if(KEYWORD_SET(FLOAT)) then $
   data = fltarr(imgdim,imgdim*nbands) $
else $
   data = bytarr(imgdim,imgdim*nbands)


for BIdx = 0, nbands - 1 do $
   data(0:imgdim-1, Bidx*imgdim:(BIdx+1)*imgdim-1) = $
       c(site*imgdim:(site+1)*imgdim-1, 0:imgdim-1,BIdx)

return, data

end
