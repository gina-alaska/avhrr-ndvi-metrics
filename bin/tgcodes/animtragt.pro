
imgdim = 94
xdim = 512 
ydim = 512

window,0, xs=xdim, ys=ydim

;=== READ FILE CONTAINING LIST OF IMAGES
;   nim             ; number of images
;   path            ; path to image files
;   classimg        ; classification path/file
;   files...        ; image file list
 
;openr, 1, "~/rad/list.94"
openr, 1, "~/rad/tgreglist.94"
 
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
ctavg=fltarr(10,nim)
cnavg=fltarr(10,nim)

;=== SET UP ANIMATION SPACE
;xinteranimate,set=[xdim,ydim,nim]


for j=0, nim-1 do begin

   jd(j) = j2d(imgname(j))                       ; Calcualte Julian Date
   print,j,jd(j)
 
   readone, path(0) + imgname(j),c,0,imgdim      ; Read Image data
 
   ndvi = getchip(c,0,5,imgdim)                  ; Extract NDVI chip
   t5 = getchip(c,0,4,imgdim)                    ; Extract band 5 chip
   t4 = getchip(c,0,3,imgdim)                    ; Extract band 4 chip
   t = tavhrr(t4,t5,4)                           ; Calculate surface T
 
   clavrreg,c,cloudtest,jd(j),0,0,0              ; Create cloud cover image
   clouds = cloudtest(*,*,0)

;=== IDENTIFY CLASSES
   tallgrass   = where (tmc eq 68  and clouds eq 0.0 , n1)
   savanna     = where (tmc eq 94  and clouds eq 0.0 , n2)
   drycropwood = where (tmc eq 14  and clouds eq 0.0 , n3)
   grasscrop   = where (tmc eq 67  and clouds eq 0.0 , n4)
   water       = where (tmc eq 205 and clouds eq 0.0 , n5)
   cropwood    = where (tmc eq 43  and clouds eq 0.0 , n6)
   drycrop     = where (tmc eq 23  and clouds eq 0.0 , n7)
   cropgrass1  = where (tmc eq 52  and clouds eq 0.0 , n8)
   cropgrass2  = where (tmc eq 53  and clouds eq 0.0 , n9)
   deciduous   = where (tmc eq 105 and clouds eq 0.0 , n10)
   evergreen   = where (tmc eq 186 and clouds eq 0.0 , n11)
   cropgrass3  = where (tmc eq 54  and clouds eq 0.0 , n12)
 
 


   ctavg(0,j) = avg(t(tallgrass))
   ctavg(1,j) = avg(t(savanna))
   ctavg(2,j) = avg(t(drycropwood))
   ctavg(3,j) = avg(t(grasscrop))
   ctavg(4,j) = avg(t(water))
   ctavg(5,j) = avg(t(cropwood))
   ctavg(6,j) = avg(t(drycrop))
   ctavg(7,j) = avg(t(cropgrass1))
   ctavg(8,j) = avg(t(cropgrass2))
   ctavg(9,j) = avg(t(deciduous))

   cnavg(0,j) = avg(ndvi(tallgrass))
   cnavg(1,j) = avg(ndvi(savanna))
   cnavg(2,j) = avg(ndvi(drycropwood))
   cnavg(3,j) = avg(ndvi(grasscrop))
   cnavg(4,j) = avg(ndvi(water))
   cnavg(5,j) = avg(ndvi(cropwood))
   cnavg(6,j) = avg(ndvi(drycrop))
   cnavg(7,j) = avg(ndvi(cropgrass1))
   cnavg(8,j) = avg(ndvi(cropgrass2))
   cnavg(9,j) = avg(ndvi(deciduous))
erase
;   plot,ctavg(*,j),cnavg(*,j),psym=3,/nodata,$
;      xrange=[280,320],$
;      yrange=[0,.8],$
;      title=jd(j),xtitle="Temperature, K",ytitle="NDVI"


;oplot,ctavg(0,0:j),cnavg(0,0:j),psym=3,color=rgb(0,0,255)
;oplot,ctavg(1,0:j),cnavg(1,0:j),psym=3,color=rgb(0,0,225)
;oplot,ctavg(2,0:j),cnavg(2,0:j),psym=6,color=rgb(0,0,255)
;oplot,ctavg(3,0:j),cnavg(3,0:j),psym=5,color=rgb(0,0,145)
;oplot,ctavg(4,0:j),cnavg(4,0:j),psym=3,color=rgb(0,0,165)
;oplot,ctavg(5,0:j),cnavg(5,0:j),psym=3,color=rgb(0,0,145)
;oplot,ctavg(6,0:j),cnavg(6,0:j),psym=3,color=rgb(0,0,125)
;oplot,ctavg(7,0:j),cnavg(7,0:j),psym=3,color=rgb(0,0,105)
;oplot,ctavg(8,0:j),cnavg(8,0:j),psym=3,color=rgb(0,0,85)
;oplot,ctavg(9,0:j),cnavg(9,0:j),psym=4,color=rgb(0,0,65)


;   data(*,*,j) = tvrd()
;   erase
;   xinteranimate,image=rotate(data(*,*,j),7),order=1,frame=j
endfor



;xinteranimate,8


   tgen=findgen(100)+230

   plot,ctavg(*,*),cnavg(*,*),psym=3,/nodata,$
      xrange=[280,310],$
      yrange=[0,.6],$
      xtitle="Temperature, K",ytitle="NDVI",color=rgb(255,255,255)

   c0c=poly_fit(ctavg(0,*),cnavg(0,*),1)
   c1c=poly_fit(ctavg(1,*),cnavg(1,*),1)
   c2c=poly_fit(ctavg(2,*),cnavg(2,*),1)
   c3c=poly_fit(ctavg(3,*),cnavg(3,*),1)
   c4c=poly_fit(ctavg(4,*),cnavg(4,*),1)
   c5c=poly_fit(ctavg(5,*),cnavg(5,*),1)
   c6c=poly_fit(ctavg(6,*),cnavg(6,*),1)
   c9c=poly_fit(ctavg(9,*),cnavg(9,*),1)

   c0f = poly(tgen,c0c)
   c1f = poly(tgen,c1c)
   c2f = poly(tgen,c2c)
   c3f = poly(tgen,c3c)
   c4f = poly(tgen,c4c)
   c5f = poly(tgen,c5c)
   c6f = poly(tgen,c6c)
   c9f = poly(tgen,c9c)

   oplot,ctavg(2,*),cnavg(2,*),psym=3,color=rgb(255,0,0)
   oplot,tgen,c2f,color=rgb(255,0,0)
   oplot,ctavg(3,*),cnavg(3,*),psym=3,color=rgb(0,255,0)
   oplot,tgen,c3f,color=rgb(0,255,0)
   oplot,ctavg(9,*),cnavg(9,*),psym=3,color=rgb(0,0,255)
   oplot,tgen,c9f,color=rgb(0,0,255)


   oplot,ctavg(0,*),cnavg(0,*),psym=3,color=rgb(255,0,255)
   oplot,tgen,c0f,color=rgb(255,0,255)
   oplot,ctavg(1,*),cnavg(1,*),psym=3,color=rgb(255,127,127)
   oplot,tgen,c1f,color=rgb(255,127,127)
   oplot,ctavg(5,*),cnavg(5,*),psym=3,color=rgb(0,255,255)
   oplot,tgen,c5f,color=rgb(0,255,255)
   oplot,ctavg(6,*),cnavg(6,*),psym=3,color=rgb(255,255,0)
   oplot,tgen,c6f,color=rgb(255,255,0)
   oplot,ctavg(4,*),cnavg(4,*),psym=3,color=rgb(127,127,255)
   oplot,tgen,c4f,color=rgb(127,127,255)

end
