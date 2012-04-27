

xdim = 512 
ydim = 512
nim = 40

data=bytarr(xdim,ydim,nim)
window,0, xs=xdim, ys=ydim
!p.multi=[0,1,2]
openr, 1, "~/rad/list.94"
imgname=strarr(nim)
readf,1,imgname
close,1 
xinteranimate,set=[xdim,ydim,nim]


readsqr,"~/rad/tgclass/tgc_mrlc.img",tmc,100
tallgrass=where(tmc eq 68)
water = where(tmc eq 205)
drycrop = where(tmc eq 23)
savanna = where(tmc eq 94)
drycropwood = where(tmc eq 14)
cropgrass = where (tmc eq 54)
evergreen = where (tmc eq 186)
deciduous = where (tmc eq 105) ;not 100% sure of this class label

tgtavg=fltarr(nim)
satavg=fltarr(nim)
dcwtavg=fltarr(nim)

tgnavg=fltarr(nim)
sanavg=fltarr(nim)
dcwnavg=fltarr(nim)
jd = fltarr(nim)

for j=0, nim-1 do begin
   readone,imgname(j),c,0
   ndvi = getchip(c,0,5,100)
   t5 = getchip(c,0,4,100)
   t4 = getchip(c,0,3,100)
   t = tavhrr(t4,t5,4)

   jd(j) = j2d(imgname(j),1994)



   tgtavg(j) = avg(t(tallgrass))
   satavg(j) = avg(t(savanna))
   dcwtavg(j) = avg(t(drycropwood))

   tgnavg(j) = avg(ndvi(tallgrass))
   sanavg(j) = avg(ndvi(savanna))
   dcwnavg(j) = avg(ndvi(drycropwood))

   plot,t,ndvi,/nodata,$
      xrange=[270,320],$
      yrange=[-.4,.8],$
      title=jd(j),xtitle="Temperature, K",ytitle="NDVI"

   oplot,t(tallgrass),ndvi(tallgrass),psym=4,color=rgb(255,0,0)
   oplot,t(savanna),ndvi(savanna),psym=5,color=rgb(100,160,150)
;   oplot,t(water),ndvi(water),psym=5,color=rgb(0,128,0)
;   oplot,t(drycrop),ndvi(drycrop),psym=6,color=rgb(0,148,192)
;   oplot,t(evergreen),ndvi(evergreen),psym=4,color=rgb(255,0,0)
;   oplot,t(deciduous),ndvi(deciduous),psym=6,color=rgb(0,0,220)
   oplot,t(drycropwood),ndvi(drycropwood),psym=6,color=rgb(0,0,205)
;   oplot,t(cropgrass),ndvi(cropgrass),psym=6,color=rgb(0,0,160)

plot,jd(0:j),tgnavg(0:j),/nodata,yrange = [0,.6],color=rgb(255,255,255),$
 xtitle="Julian Day",ytitle="NDVI",xrange=[40,250]
oplot,jd(0:j),tgnavg(0:j),color=rgb(255,0,0),psym=-4
oplot,jd(0:j),sanavg(0:j),color=rgb(100,160,150),psym=-5
oplot,jd(0:j),dcwnavg(0:j),color=rgb(0,0,205),psym=-6

;plot,jd(0:j),tgtavg(0:j),/nodata,yrange = [280,310],color=rgb(255,255,255),$
; xtitle="Julian Day",ytitle="Temperature, K",xrange=[40,250]
;oplot,jd(0:j),tgtavg,color=rgb(255,0,0),psym=-4
;oplot,jd(0:j),satavg,color=rgb(100,160,150),psym=-5
;oplot,jd(0:j),dcwtavg,color=rgb(0,0,205),psym=-6



   data(*,*,j) = tvrd()
   erase
   xinteranimate,image=rotate(data(*,*,j),7),order=1,frame=j
endfor



xinteranimate,8

end

