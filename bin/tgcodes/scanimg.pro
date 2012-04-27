pro	scanimg, t, nd, jd

;
; version of plotimg.pro designed to "step through" images
; gutted version of Manuel's "animimgplot.pro" designed to look at
; individual dates (NDVI vs. temp)
;
; parameters:
;

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

jd = fltarr(nim)

window, 0
window, 2, xs=3*imgdim, ys=imgdim

for j=0, nim-1 do begin

  jd(j) = j2d(imgname(j))
  print, j, jd(j), imgname(j)
  readone, path(0) + imgname(j), c, 0, imgdim

  nd = getchip(c,0,5,imgdim)
  t5 = getchip(c,0,4,imgdim)
  t4 = getchip(c,0,3,imgdim)
  t = tavhrr(t4,t5,4)

  wset, 0
  plot, nd, t, psym=2, ystyle=16
  oplot, [-1,1],[8.0,8.0], line = 1

  wset, 2
  tvbuf = bytarr(3*imgdim, imgdim)
  tvbuf(0:imgdim-1,*) = bytscl (float (nd))
  tvbuf(imgdim:2*imgdim-1,*) = bytscl (float (t))
  tv, tvbuf

loopie:
  wset, 0
  cursor, nd0, t0, wait=1
  wait, 1
  cursor, nd1, t1, wait=1
  nmin = min ([nd0, nd1])
  nmax = max ([nd0, nd1])
  tmin = min ([t0, t1])
  tmax = max ([t0, t1])
  print, nmin, nmax, tmin, tmax
  oplot, [nmin, nmin, nmax, nmax, nmin],$
    [tmin, tmax, tmax, tmin, tmin], line=1

  wset, 2
  tt = (t ge tmin)*(t le tmax)
  nn = (nd ge nmin)*(nd le nmax)
  tvbuf(2*imgdim:3*imgdim-1,*) = bytscl (tt * nn)
  tv, tvbuf
  print, "any more? (1-yes, 0-no)"
  read, answer
  if (answer eq 1) then goto, loopie

endfor

return
end
