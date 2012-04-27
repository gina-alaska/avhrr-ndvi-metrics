;======   READSQR   ===================================
; This script reads a dim by dim byte image from 'file'
;======================================================

pro   readsqr,file,ch,dim

ch = fltarr(dim,dim)

openr,1,file

pix=assoc(1,bytarr(dim,dim))
;ch(*,*) = float(rotate(pix(0),7))
ch(*,*) = float(pix(0))

close,1

end
