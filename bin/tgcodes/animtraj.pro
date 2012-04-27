imgdim = 94
xdim = 512 
ydim = 512

window,0, xs=xdim, ys=ydim

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
ctavg=fltarr(20,nim)
cnavg=fltarr(20,nim)

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
   tallgrass   = where (tmc eq 68  and clouds eq 0.0 and ndvi gt 0.0, n1)
   savanna     = where (tmc eq 94  and clouds eq 0.0 and ndvi gt 0.0, n2)
   drycropwood = where (tmc eq 14  and clouds eq 0.0 and ndvi gt 0.0, n3)
   grasscrop   = where (tmc eq 67  and clouds eq 0.0 and ndvi gt 0.0, n4)
   water       = where (tmc eq 205 and clouds eq 0.0 and ndvi gt 0.0, n5)
   cropwood    = where (tmc eq 43  and clouds eq 0.0 and ndvi gt 0.0, n6)
   drycrop     = where (tmc eq 23  and clouds eq 0.0 and ndvi gt 0.0, n7)
   cropgrass1  = where (tmc eq 52  and clouds eq 0.0 and ndvi gt 0.0, n8)
   cropgrass2  = where (tmc eq 53  and clouds eq 0.0 and ndvi gt 0.0, n9)
   deciduous   = where (tmc eq 105 and clouds eq 0.0 and ndvi gt 0.0, n10)
   evergreen   = where (tmc eq 186 and clouds eq 0.0 and ndvi gt 0.0, n11)
   cropgrass3  = where (tmc eq 54  and clouds eq 0.0 and ndvi gt 0.0, n12)
   winterwheat  = where (tmc eq 17  and clouds eq 0.0 and ndvi gt 0.0, n13)
 


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

   if(n13 gt 0) then $
      ctavg(12,j) = avg(t(winterwheat))$
   else $
      ctavg(12,j) = ctavg(12,j-1)

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

   if(n13 gt 0) then $
      cnavg(12,j) = avg(ndvi(winterwheat))$
   else $
      cnavg(12,j) = cnavg(12,j-1)

erase
endfor




   jdgen=findgen(250)

   plot,jd(*),cnavg(*,*),psym=3,/nodata,$
      xrange=[30,250],$
      yrange=[0,.6],$
      xtitle="Julian Day",ytitle="NDVI",color=rgb(255,255,255)


   c0c=poly_fit(jd(*),cnavg(0,*),3)
   c1c=poly_fit(jd(*),cnavg(1,*),3)
   c2c=poly_fit(jd(*),cnavg(2,*),3)
   c3c=poly_fit(jd(*),cnavg(3,*),3)
   c4c=poly_fit(jd(*),cnavg(4,*),3)
   c5c=poly_fit(jd(*),cnavg(5,*),3)
   c6c=poly_fit(jd(*),cnavg(6,*),3)
   c9c=poly_fit(jd(*),cnavg(9,*),3)
   c12=poly_fit(jd(*),cnavg(12,*),3)

   c0f = poly(jdgen,c0c)
   c1f = poly(jdgen,c1c)
   c2f = poly(jdgen,c2c)
   c3f = poly(jdgen,c3c)
   c4f = poly(jdgen,c4c)
   c5f = poly(jdgen,c5c)
   c6f = poly(jdgen,c6c)
   c9f = poly(jdgen,c9c)
   c12 = poly(jdgen,c12)

   oplot,jd(*),cnavg(2,*),psym=3,color=rgb(255,0,0)
   oplot,jdgen,c2f,color=rgb(255,0,0)
   oplot,jd(*),cnavg(3,*),psym=3,color=rgb(0,255,0)
   oplot,jdgen,c3f,color=rgb(0,255,0)
   oplot,jd(9,*),cnavg(9,*),psym=3,color=rgb(0,0,255)
   oplot,jdgen,c9f,color=rgb(0,0,255)


   oplot,jd(*),cnavg(0,*),psym=3,color=rgb(255,0,255)
   oplot,jdgen,c0f,color=rgb(255,0,255)
   oplot,jd(*),cnavg(1,*),psym=3,color=rgb(255,127,127)
   oplot,jdgen,c1f,color=rgb(255,127,127)
   oplot,jd(*),cnavg(5,*),psym=3,color=rgb(0,255,255)
   oplot,jdgen,c5f,color=rgb(0,255,255)
   oplot,jd(*),cnavg(6,*),psym=3,color=rgb(255,255,0)
   oplot,jdgen,c6f,color=rgb(255,255,0)
   oplot,jd(*),cnavg(4,*),psym=3,color=rgb(127,127,255)
   oplot,jdgen,c4f,color=rgb(127,127,255)
   oplot,jd(*),cnavg(12,*),psym=3,color=rgb(255,255,127)
   oplot,jdgen,c12,color=rgb(255,255,127)

end
