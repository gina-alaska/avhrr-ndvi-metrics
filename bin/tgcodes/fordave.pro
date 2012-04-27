!order=1

file = "us_05171924_oklahoma.img"
cfile = "../landclass/okclassnew.img"

data = imgread3(file, 512,512,10, /i2)
datau = avhrrunscale(data, /i2, /ref)

class = imgread(cfile, 512,512,1)

ndvi = datau(*,*,5)
t4 = datau(*,*,3)
t5 = datau(*,*,4)

t = tavhrr(t4,t5,4)

jd = file2jul(file, year=1996)

clavr2, datau, clouds, jd

wcidx = where (class eq 149)
wmsks = mask(class, wcidx, /show)
wmskh = mask(class, wcidx, /hide)

clidx = where (clouds(*,*,0) gt 0)
cmsks = mask(clouds(*,*,0), clidx, /show)
cmskh = mask(clouds(*,*,0), clidx, /hide)

nd3 = bytscl(make3band(ndvi))

window, 1, xs=512,ys=512
tvscl, nd3, true=3
overlay, nd3, cmsks, color=[255,255,255]
overlay, nd3, wmsks, color=[0,0,255]


window, 2
plot, t*cmskh*wmskh, ndvi*cmskh*wmskh, psym=3, xrange=[260,340],$
      color=rgb(0,255,0) 
;oplot, t*cmsks, ndvi*cmsks, psym=3, color=rgb(255,255,255)
;oplot, t*wmsks, ndvi*wmsks, psym=3, color=rgb(0,0,255)


end
