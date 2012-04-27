pro   plotclass,cimg,img,ndvi,t,tmc

readsqr,cimg,tmc,100
readlac,img,c,1

ndvi = getchip(c,0,5,100)
t5 = getchip(c,0,4,100)
t4 = getchip(c,0,3,100)
t = tavhrr(t4,t5,4)

water = where(tmc eq 205)
tallgrass = where(tmc eq 68)
savanna = where(tmc eq 94)
cropwood1 = where(tmc eq 14)
cropwood2 = where(tmc eq 23)
deciduous1 = where(tmc eq 104)
cropgrass = where(tmc eq 53)
evergreen = where(tmc eq 186)
grasscrop = where(tmc eq 94)

window,10
plot,t,ndvi,xrange=[min(t),max(t)], $
 yrange=[min(ndvi),max(ndvi)], psym=3,color = rgb(255,255,255)

;oplot,t(water),ndvi(water),psym=4,color=rgb(64,64,255)
;oplot,t(savanna),ndvi(savanna),psym = 5 ,color = rgb(255,255,0)
;oplot,t(tallgrass),ndvi(tallgrass),psym=6,color=rgb(0,255,0)
;oplot,t(cropwood1),ndvi(cropwood1),psym=7,color=rgb(255,128,128)
;oplot,t(cropwood2),ndvi(cropwood2),psym=4,color=rgb(255,128,128)
;oplot,t(grasscrop),ndvi(grasscrop),psym=5,color=rgb(255,255,128)



return
end

