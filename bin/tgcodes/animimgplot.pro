;=== PROGRAM - ANIMIMGPLOT



;=== SET UP OUTPUT SPACE
imgdim =94                           ; chip dimension (assumed square)	
xdim = 2*imgdim 
ydim = 5*imgdim
;window,0, xs=xdim, ys=ydim
cloudscore = 0.0

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


;=== GET COEFFICIENTS TO SCALE DATA TO OUTPUT SPACE
at=scalecoef(270.,320.,0.,imgdim-1)
an=scalecoef(-0.4,0.8,0.,imgdim-1)


for j=0, nim-1 do begin
   jd(j) = j2d(imgname(j),1994)                       ; Calcualte Julian Date
   print,j,jd(j)

   readone, path(0) + imgname(j),c,0,imgdim      ; Read Image data

   ndvi = getchip(c,0,5,imgdim)                  ; Extract NDVI chip
   t5 = getchip(c,0,4,imgdim)                    ; Extract band 5 chip	
   t4 = getchip(c,0,3,imgdim)                    ; Extract band 4 chip
   t = tavhrr(t4,t5,4)                           ; Calculate surface T  

   clavrreg,c,cloudtest,jd(j),0,0,0              ; Create cloud cover image
   clouds = cloudtest(*,*,0)


;=== IDENTIFY CLASSES 
   tallgrass   = where (tmc eq 68  and clouds eq cloudscore , n1)
   savanna     = where (tmc eq 94  and clouds eq cloudscore , n2)
   drycropwood = where (tmc eq 14  and clouds eq cloudscore , n3)
   grasscrop   = where (tmc eq 67  and clouds eq cloudscore , n4)
   water       = where (tmc eq 205 and clouds eq cloudscore , n5)
   cropwood    = where (tmc eq 43  and clouds eq cloudscore , n6)
   drycrop     = where (tmc eq 23  and clouds eq cloudscore , n7)
   cropgrass1  = where (tmc eq 52  and clouds eq cloudscore , n8)
   cropgrass2  = where (tmc eq 53  and clouds eq cloudscore , n9)
   deciduous   = where (tmc eq 105 and clouds eq cloudscore , n10) 
   winterwheat = where (tmc eq 17  and clouds eq cloudscore , n13)
   evergreen   = where (tmc eq 186 and clouds eq cloudscore , n11)
   cropgrass3  = where (tmc eq 54  and clouds eq cloudscore , n12)
   

;=== IDENTIFY NON-CLOUD, NON-WATER PIXELS 
noclouds = where (clouds eq 0.0  and tmc ne 205 and ndvi ge 0.0)


;=== SCALE TEMPERATURE AND NDVI TO OUTPUT SPACE

;   tavg = avg(t(noclouds))
;   at=scalecoef(tavg-12.0,tavg+12.0,0.,imgdim-1)

   ts = poly(t,at)
   ns = poly(ndvi,an) 


;=== GENERATE IMAGE PLOT FOR ALL DATA
   imgplot=fltarr(xdim,ydim)
   
   imgplot(ts(noclouds)        ,ns(noclouds)         ) = 1.0
   imgplot(ts(noclouds)+imgdim ,ns(noclouds)         ) = 1.0
   imgplot(ts(noclouds)        ,ns(noclouds)+  imgdim) = 1.0
   imgplot(ts(noclouds)+imgdim ,ns(noclouds)+  imgdim) = 1.0
   imgplot(ts(noclouds)        ,ns(noclouds)+2*imgdim) = 1.0
   imgplot(ts(noclouds)+imgdim ,ns(noclouds)+2*imgdim) = 1.0
   imgplot(ts(noclouds)        ,ns(noclouds)+3*imgdim) = 1.0
   imgplot(ts(noclouds)+imgdim ,ns(noclouds)+3*imgdim) = 1.0
   imgplot(ts(noclouds)        ,ns(noclouds)+4*imgdim) = 1.0
   imgplot(ts(noclouds)+imgdim ,ns(noclouds)+4*imgdim) = 1.0


;=== GENERATE IMAGE PLOT DATA FOR DIFFERENT CLASSES
   imgplot(ts(tallgrass)         ,ns(tallgrass)           ) = 0.5
   imgplot(ts(savanna)+imgdim    ,ns(savanna)             ) = 0.5
   imgplot(ts(drycropwood)       ,ns(drycropwood)+imgdim  ) = 0.5
   imgplot(ts(grasscrop)+imgdim  ,ns(grasscrop)+imgdim    ) = 0.5
   imgplot(ts(water)             ,ns(water)+2*imgdim      ) = 0.5
   imgplot(ts(cropwood)+imgdim   ,ns(cropwood)+2*imgdim   ) = 0.5
   imgplot(ts(drycrop)           ,ns(drycrop)+3*imgdim    ) = 0.5
   imgplot(ts(cropgrass1)+imgdim ,ns(cropgrass1)+3*imgdim ) = 0.5 
   if(n13 gt 0) then $
    imgplot(ts(winterwheat)        ,ns(winterwheat)+4*imgdim ) = 0.5
   imgplot(ts(deciduous)+imgdim  ,ns(deciduous)+4*imgdim  ) = 0.5

 
;=== CREATE LINES TO SEPARATE IMAGE PLOTS
   imgplot(xdim/2,*) = 1.0
   imgplot(*,ydim/5) = 1.0
   imgplot(*,2*ydim/5) = 1.0
   imgplot(*,3*ydim/5) = 1.0
   imgplot(*,4*ydim/5) = 1.0
   
;   tvscl,imgplot

;   data(*,*,j) = tvrd()
;   erase

data(*,*,j) =scale(imgplot,XMin=0,XMax=255)

;=== LOAD ANIMATION DATA
   xinteranimate,image=rotate(data(*,*,j),7),order=1,frame=j

endfor


;=== RUN ANIMATION, STORE PIXEL MAPS
xinteranimate,8,/keep_pixmaps

end

