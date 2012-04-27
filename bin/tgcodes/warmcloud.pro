PRO WarmCloud, listfile

readlist, listfile, nim, path, file

Tmax = 295.0
Dim = 512L
OpenW, 10, "clouds96.out"

FOR i = 0, nim-1 DO BEGIN
   pathfile = path(0)+file(i)

;print, "READING IMAGE "+file(i)
   data = imgread(pathfile, Dim,Dim,10, /i2, /order)
;print, "UNSCALING"
   datau = avhrrunscale(data, /i2, /ref)
   jd = file2jul(file(i), year=1996)

;print, "RUNNING CLAVR"
   clavr, datau, clouds, jd

   T4 = getband(datau, 3)

   BadIdx = where((clouds[*,*,2] eq 1 and clouds[*,*,0] eq 1) or $
                  (clouds[*,*,1] eq 1 and clouds[*,*,0] eq 1) or $
                  (clouds[*,*,1] eq 1 and clouds[*,*,2] eq 1 and $
                   clouds[*,*,0] eq 2))

   BadMask = Mask(clouds[*,*,0], BadIdx, /Show)

   WarmIdx = where(T4 ge Tmax)

   WarmMask = Mask(T4, WarmIdx, /Hide)

   BadMask = BadMask*WarmMask

   B1Mask = Clouds[*,*,1]*BadMask
   NDMask = Clouds[*,*,2]*BadMask

   CldMask = B1Mask + NDMask + clouds[*,*,3] + clouds[*,*,4] + clouds[*,*,5] 

NCloud = N_Elements(Where(CldMask gt 0))
printf, 10, file(i), 100.0*NCloud/(Dim^2)
print, file(i), 100.0*NCloud/(Dim^2),"%"

;print, "SHOWING IMAGES"
;Showsite, Clouds[*,*,0], 0, file(i)+": Old Mask"
;Showsite, CldMask, 1, file(i)+": New Mask"
;Showsite, alog(getband(data,0)),2,file(i)+": Band 1"
;Showsite, getband(data,5), 3, file(i)+": NDVI"
;cursor, x,y, /wait


ENDFOR

Close, 10

END
