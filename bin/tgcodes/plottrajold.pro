PRO   plottraj, listfile,site
SEGDAYS = 14   ; bin up images in 14 day segments
WINDOWNUM = 2

readlist2,listfile,nim,imgdim,path,classimg,imgname
window, WINDOWNUM, xs=3*imgdim, ys=imgdim

;=== SET UP LIST OF JULIAN DATES FOR FILES
jd = fltarr(nim)
for i=0, nim-1 do jd(i) = j2d(imgname(i))

for i=0,300,SEGDAYS do begin

  seg = where(jd ge i and jd lt i+SEGDAYS, nsegs)

  if (nsegs gt 0) then begin

    for j = 0, nsegs-1 do begin

        readone, path(0)+ imgname(seg(j)),c,0,imgdim

        ndvi = getchip(c,0,5,imgdim)               ; Extract NDVI chip
        t5 = getchip(c,0,4,imgdim)                 ; Extract band 5 chip
        t4 = getchip(c,0,3,imgdim)                 ; Extract band 4 chip
        t = tavhrr(t4,t5,4)                        ; Calculate surface T

        clavrreg,c,cloudtest,jd(seg(j)),0,site,0   ; Create cloud cover image
        clouds = cloudtest(*,*,0)
        mask = clouds*0 + 1
        mask(where (clouds gt 0)) = 0
tvscl, ndvi, 0, 0
tvscl, t, imgdim, 0
tvscl, clouds,  2*imgdim, 0
;tvscl, mask,  3*imgdim, 0

print, i, jd(seg(j)), j, nsegs, '  ',imgname(seg(j))

     box = selectchip(WINDOWNUM)
print, box
wait, 1

     endfor 

  endif 

endfor

end
