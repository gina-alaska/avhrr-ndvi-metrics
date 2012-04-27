pro	plotimg, cloudflag

;
; gutted version of Manuel's "animimgplot.pro" designed to look at
; individual dates (NDVI vs. temp)
;
; parameters:
;		cloudflag	1 - screen for clouds
;				0 - don't screen
;

imgdim =94 
xdim = 2*imgdim 
ydim = 5*imgdim

;=== READ FILE CONTAINING LIST OF IMAGES
;   nim
;   path
;   classimg
;   files...

openr, 1, "/sg1/sabres/meyer/suarezm/rad/tgreglist.94"

readf,1,nim

path = strarr(1)
readf,1,path

classimg = strarr(1)
readf,1,classimg

imgname=strarr(nim)
data=bytarr(xdim,ydim,nim)

readf,1,imgname
close,1 

jd = fltarr(nim)

for j=0, nim-1 do begin
   jd(j) = j2d(imgname(j))
   print,j,jd(j),path(0)+imgname(j)
endfor

print, 'enter j for desired date'
read, j

   readone, path(0) + imgname(j), c, 0, imgdim

   ndvi = getchip(c,0,5,imgdim)
   t5 = getchip(c,0,4,imgdim)
   t4 = getchip(c,0,3,imgdim)
   t = tavhrr(t4,t5,4)

window, 0

if (cloudflag ne 1) then begin
   clavrreg,c,cloudtest,jd(j),0,0,0
   clouds = cloudtest(*,*,0)
   noclouds = where (clouds eq 0.0  and ndvi ge 0.0)
   plot, ndvi(noclouds), t(noclouds), psym=2, ystyle=16
endif else begin
   plot, ndvi, t, psym=2, ystyle=16
endelse

window, 2, xs=2*imgdim, ys=imgdim
tvbuf = bytarr(2*imgdim, imgdim)
tvbuf(0:imgdim-1,*) = bytscl (float (ndvi))
tvbuf(imgdim:2*imgdim-1,*) = bytscl (float (t))
tv, tvbuf

return
end
