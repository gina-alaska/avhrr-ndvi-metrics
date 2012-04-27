CitLat = [415, 335, 169]
CitLon = [163, 298, 172] 
NSamps = 512
NLines = 512
NBands = 10
off = 3
!order=1

readlist, "mayjunjul", nim, path, files

MinND = fltarr(4, nim)
MaxT = fltarr(4, nim)

FOR i = 0, nim - 1 DO BEGIN

   pathfile = path(0) + files(i)
   jd = file2jul(files(i), year=1996)
   data = imgread(pathfile, NSamps, NLines, NBands, /I2)
   datau = avhrrunscale(data, /ref, /i2)
   clavr2, datau, clouds, jd


   ND = getband(data, 5)
   T4 = getband(datau, 3)
   T5 = getband(datau, 4)
   T = TAvhrr(T4, T5, 4)
window, 0, xs = 512,ys=512
tvscl, clouds(*,*,0)
window, 1, xs = 512,ys=512
tvscl, alog(data(*,0:511))
window, 2, xs = 512,ys=512
tvscl, T 
window, 3, xs = 512,ys=512
tvscl, ND 

   MinND(0, i) = jd 
   MaxT(0, i) = jd 

   FOR j = 0, 2 DO BEGIN
   
      CityND = ND(CitLon(j)-off: CitLon(j)+off, CitLat(j)-off: CitLat(j)+off)
      CityT  =  T(CitLon(j)-off: CitLon(j)+off, CitLat(j)-off: CitLat(j)+off)

      CitCloud = clouds(CitLon(j)-off: CitLon(j)+off, $
                        CitLat(j)-off: CitLat(j)+off, 0)

      idx = where(citcloud eq 0, nidx)
      if (nidx gt 0) then BEGIN
         MinCityND = i2nd(min(CityND(idx))) 
         MaxCityT =  max(CityT(idx)) 
      ENDIF ELSE BEGIN
         MinCityND = -1.
         MaxCityT = 999.
      ENDELSE
      MinND(j+1, i) = MinCityND
      MaxT(j+1, i) = MaxCityT
   ENDFOR
print, MinND(*, i), MaxT(*,i), Max(T)

cursor, x,y, /wait
ENDFOR
window, 4
plot, minnd(0,*), minnd(1,*), /nodata, yrange=[-.1,.3], /xstyle
oplot, minnd(0,*), minnd(1,*), color=rgb(255,0,0), psym=4
oplot, minnd(0,*), minnd(2,*), color=rgb(0,255,0), psym=4
oplot, minnd(0,*), minnd(3,*), color=rgb(0,0,255), psym=4

window,5
plot, maxt(0,*), maxt(1,*), /nodata, yrange=[290, 320], /xstyle
oplot, maxt(0,*), maxt(1,*), color=rgb(255,0,0), psym=4
oplot, maxt(0,*), maxt(2,*), color=rgb(0,255,0), psym=4
oplot, maxt(0,*), maxt(3,*), color=rgb(0,0,255), psym=4

END      
