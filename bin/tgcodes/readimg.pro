pro	readimg, tt, nn, jd, cl

;
; version of plotimg.pro designed to "step through" images
; gutted version of Manuel's "animimgplot.pro" designed to look at
; individual dates (NDVI vs. temp)
;
; also includes cloud tests
;
; parameters:
;
;	tt	surface temperature kelvins (94,94,nim)
;	nn	ndvi (etc.)
;	jd	julian dates (nim)
;	cl	cloud tests (94,94,nim)

imgdim =94 
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

readf,1,imgname
close,1 

nn = fltarr(imgdim,imgdim,nim) & tt = nn & cl = nn
jd = fltarr(nim)

for j=0, nim-1 do begin

  jd(j) = j2d(imgname(j))
  print, j, jd(j), ' ', imgname(j)
  readone, path(0) + imgname(j), c, 0, imgdim

;
;ndvi (already computed)
;

  nn(*,*,j) = getchip(c,0,5,imgdim)

;
; surface temps (algorithm 4 is after Singh)
;

  t5 = getchip(c,0,4,imgdim)
  t4 = getchip(c,0,3,imgdim)
  tt(*,*,j) = tavhrr(t4,t5,4)

;
; cloud tests
;

  clavrreg,c,cloudtest,jd(j),0,0,0
  cl(*,*,j) = cloudtest(*,*,0)

endfor

return
end
