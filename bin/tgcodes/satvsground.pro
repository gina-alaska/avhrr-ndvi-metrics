PRO   satvsground 

;=== Get ground data from 1994 Niobrara data set ===
readhrly, g


;=== Read image listfile ===
listfile='~/rad/lists/nb94.list'
readlist2,listfile,nim,imgdim,path,classimg,imgname


;=== CREATE ARRAYS ===
jd = fltarr(nim)
site = 2
GMT = 6
ta=fltarr(nim)
tg=fltarr(nim)
ts1=fltarr(nim)
ts2=fltarr(nim)
ts3=fltarr(nim)
ts4=fltarr(nim)
tains4=fltarr(nim)
stdevts=fltarr(nim)

for j = 0,nim-1 do begin

   jd(j) = j2d(imgname(j))                       ; Calcualte Julian Date
   
   mo=strmid(imgname(j),2,2)
   day=strmid(imgname(j),4,2)
   hr =strmid(imgname(j),6,2) - GMT
   min=strmid(imgname(j),8,2)

   hrlow = where(g(0,*) eq mo  and  g(1,*) eq day  and  g(2,*) eq hr*100)
;   hrhi  = where(g(0,*) eq mo  and  g(1,*) eq day  and  g(2,*) eq (hr+1)*100)

   readone, path(0) + imgname(j),c,0,imgdim
   ndvi = getchip(c,0,5,imgdim)                  ; Extract NDVI chip
   t5 = getchip(c,0,4,imgdim)                    ; Extract band 5 chip
   t4 = getchip(c,0,3,imgdim)                    ; Extract band 4 chip
   talg1 = tavhrr(t4,t5,1)                           ; Calculate surface T
   talg2 = tavhrr(t4,t5,2)                           ; Calculate surface T
   talg3 = tavhrr(t4,t5,3)                           ; Calculate surface T
   talg4 = tavhrr(t4,t5,4)                           ; Calculate surface T
   tains = imgcopy(talg4,40,10,10,10)


   clavrreg,c,cloudtest,jd(j),0,site,0           ; Create cloud cover image
   clouds = cloudtest(*,*,0)
   cloudains=imgcopy(clouds,40,10,10,10)

   noclouds= where(clouds eq 0 , nc)
   nocloudains= where(cloudains eq 0 , nca)

   print, j,' ',jd(j),' ',nc,nca

if nca gt 1 then begin 
   ta(j) = g(3,hrlow)
   tg(j) = g(5,hrlow)
   ts1(j) = k2f(avg(talg1(noclouds)))
   ts2(j) = k2f(avg(talg2(noclouds)))
   ts3(j) = k2f(avg(talg3(noclouds)))
   ts4(j) = k2f(avg(talg4(noclouds)))
   tains4(j) = k2f(avg(tains(nocloudains)))
   stdevts(j) = stdev(talg4(nocloudains))
endif

endfor 


;=== PLOT RESULTS ===
line =findgen(81)+20

window,0,xs=500,ys=500
plot,ta,ts1,xtitle='T(air)', ytitle='T(satellite)', $
   xrange=[20,100],yrange=[20,100],$
   /nodata,/ynozero,color=rgb(255,255,255)

;oplot,ta,ts1,psym=5 ,color=rgb(255,0,0) 
;oplot,ta,ts2,psym=5 ,color=rgb(0,255,0) 
;oplot,ta,ts3,psym=5 ,color=rgb(0,0,255) 
oplot,ta,ts4,psym=5 ,color=rgb(0,255,255) 
oplot,ta,tains4,psym=5 ,color=rgb(255,255,0) 

oplot,line,line,color=rgb(255,255,255)


window,1,xs=500,ys=500
plot,tg,ts1,xtitle='T(soil)', ytitle='T(satellite)', $
   xrange=[20,100],yrange=[20,100],$
   /nodata,/ynozero,color=rgb(255,255,255)

;oplot,tg,ts1,psym=4 ,color=rgb(255,0,0) 
;oplot,tg,ts2,psym=4 ,color=rgb(0,255,0) 
;oplot,tg,ts3,psym=4 ,color=rgb(0,0,255) 
oplot,tg,ts4,psym=4 ,color=rgb(0,255,255) 
oplot,tg,tains4,psym=4 ,color=rgb(255,255,0) 

oplot,line,line,color=rgb(255,255,255)

;window, 2
;plot,jd,stdevts
ainsexist = where(tains ne 0)

print, total(sqrt((tains4(ainsexist) - ta(ainsexist))^2)/n_elements(ainsexist))
print, total(sqrt((ts4 - ta)^2)/n_elements(ts4))
;print, sqrt((ts4 - ta)^2)
end
