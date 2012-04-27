;=== PROGRAM - ANIMIMGPLOT
PRO   animimgplotgen, listfile,nclasses,site

;nclasses = number of classes to use 
;site - 0 = Tallgrass, 2 = Niobrara

readlist2,listfile,nim,imgdim,path,classimg,imgname

readsqr,classimg(0),tmc,imgdim
getclasses,tmc,nclasses,classes,n_inclasses
ngood = intarr(nclasses)

;=== SET UP OUTPUT SPACE
xdim = 2*imgdim 
ydim = nclasses/2*imgdim
window,0, xs=xdim, ys=ydim
cloudscore = 0.0


;=== CREAT ARRAYS FOR STORING ANIMATION DATA AND JULIAN DATE
data=bytarr(xdim,ydim,nim)
jd = fltarr(nim)


;=== SET UP ANIMATION SPACE
xinteranimate,set=[xdim,ydim,nim]


;=== GET COEFFICIENTS TO SCALE DATA TO OUTPUT SPACE
at=scalecoef(270.,320.,0.,imgdim-1)
an=scalecoef(-0.4,0.8,0.,imgdim-1)


for j=0, nim-1 do begin
   jd(j) = j2d(imgname(j), 1994)                       ; Calcualte Julian Date
   print,j,jd(j)
erase
   readone, path(0) + imgname(j),c,0,imgdim      ; Read Image data

   ndvi = getchip(c,0,5,imgdim)                  ; Extract NDVI chip
   t5 = getchip(c,0,4,imgdim)                    ; Extract band 5 chip	
   t4 = getchip(c,0,3,imgdim)                    ; Extract band 4 chip
   t = tavhrr(t4,t5,4)                           ; Calculate surface T  

   clavrreg,c,cloudtest,jd(j),0,site,0           ; Create cloud cover image
   clouds = cloudtest(*,*,0)

class=fltarr(nclasses,max(n_inclasses))
;=== IDENTIFY CLASSES 
   for i = 0, nclasses-1 do begin
      c = where(tmc eq classes(i) and clouds eq cloudscore,n)
      ngood(i) = n
      if(n gt 0 ) then class(i,0:n-1) = c
   endfor 

;=== IDENTIFY NON-CLOUD, NON-WATER PIXELS 
noclouds = where (clouds eq cloudscore  and tmc ne 205 and ndvi ge 0.0,nc)


;=== SCALE TEMPERATURE AND NDVI TO OUTPUT SPACE
   ts = poly(t,at)
   ns = poly(ndvi,an) 


;=== GENERATE IMAGE PLOT FOR ALL DATA
   imgplot=fltarr(xdim,ydim)
    
   for i = 0,nclasses/2 - 1 do begin 
      for k = 0,1 do begin
         if nc gt 0 then $
            imgplot(ts(noclouds)+k*imgdim ,ns(noclouds)+i*imgdim) = 1.0
      endfor
   endfor


;=== GENERATE IMAGE PLOT DATA FOR DIFFERENT CLASSES
   for i = 0,nclasses/2 - 1 do begin
      for k = 0,1 do begin
      if(ngood(i*2+k) gt 0) then $
         imgplot(ts(class(i*2+k,0:ngood(i*2+k)))+k*imgdim,$
                 ns(class(i*2+k,0:ngood(i*2+k)))+i*imgdim) = 0.5
      endfor
   endfor

 
;=== CREATE LINES TO SEPARATE IMAGE PLOTS
   imgplot(xdim/2,*) = 1.0
   for i = 1, nclasses/2 -1 do begin
      imgplot(*,i*ydim/(nclasses/2)) = 1.0
   endfor 


   tvscl,imgplot

;   data(*,*,j) = tvrd()
;   erase

data(*,*,j) =scale(imgplot,XMIN=0,XMAX=255)

;=== LOAD ANIMATION DATA
   xinteranimate,image=rotate(data(*,*,j),7),order=1,frame=j

endfor


;=== RUN ANIMATION, STORE PIXEL MAPS
xinteranimate,8,/keep_pixmaps

end

