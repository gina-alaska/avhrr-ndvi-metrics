

xdim = 512 
ydim = 512

window,0, xs=xdim, ys=ydim
!p.multi=[0,1,2]

;=== READ FILE CONTAINING LIST OF IMAGES
;   nim             ; number of images
;   path            ; path to image files
;   classimg        ; classification path/file
;   files...        ; image file list
 
;openr, 1, "~/rad/lists/list.94"
openr, 1, "~/rad/lists/tgreglist.94"
 
readf,1,nim
 
path = strarr(1)
readf,1,path
 
classimg = strarr(1)
readf,1,classimg
 
imgname=strarr(nim)
readf,1,imgname
 
close,1
 
readsqr,classimg(0),tmc,imgdim

;=== CREAT ARRAYS FOR STORING ANIMATION DATA AND JULIAN DATE
data=bytarr(xdim,ydim,nim)
jd = fltarr(nim)

;=== SET UP ANIMATION SPACE
xinteranimate,set=[xdim,ydim,nim]


for j=0, nim-1 do begin
   readone,imgname(j),c,0
   ndvi = getchip(c,0,5,100)
   t5 = getchip(c,0,4,100)
   t4 = getchip(c,0,3,100)
   t = tavhrr(t4,t5,4)

   jd(j) = j2d(imgname(j),1994)




   plot,t,ndvi,/nodata,$
      xrange=[270,320],$
      yrange=[-.4,.8],$
      title=jd(j),xtitle="Temperature, K",ytitle="NDVI"

;   oplot,t(tallgrass),ndvi(tallgrass),psym=4,color=rgb(255,0,0)
;   oplot,t(savanna),ndvi(savanna),psym=5,color=rgb(100,160,150)
;   oplot,t(water),ndvi(water),psym=5,color=rgb(0,128,0)
;   oplot,t(drycrop),ndvi(drycrop),psym=6,color=rgb(0,148,192)
;   oplot,t(evergreen),ndvi(evergreen),psym=4,color=rgb(255,0,0)
;   oplot,t(deciduous),ndvi(deciduous),psym=6,color=rgb(0,0,220)
;   oplot,t(drycropwood),ndvi(drycropwood),psym=6,color=rgb(0,0,205)
;   oplot,t(cropgrass),ndvi(cropgrass),psym=6,color=rgb(0,0,160)

oplot,tgtavg(j),tgnavg(j),psym=4,color=rgb(255,0,0)
oplot,satavg(j),sanavg(j),psym=4,color=rgb(100,160,150)
oplot,dcwtavg(j),dcwnavg(j),psym=6,color=rgb(0,0,205)


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

