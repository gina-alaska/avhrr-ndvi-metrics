;=== NOAA14FIX ===
;  This procedure reads all

@noaa14cal.h

readlist, "~/rad/us96/tg96good/jon/imglist", nim, path, files

;readlist, "~/rad/us96/tg96/tg96.goodlist", nim, path, files
;readlist, "~/rad/us96/tg96good/noclouds5", nim, path, files
ns = 100
nl = 1200
goodpath = "/sg1/sab1/suarezm/rad/us96/tg96good/"
openw,20, goodpath+"cloudcover"

for i = 0, nim-1 do begin
   pathfile = path+files(i)
   jd = j2d(files(i), 1996, 4)

   data = imgread(pathfile(0), ns, ns, 12, /order)
   dataold = data

   T3 = getband(data, 2)
   T4 = getband(data, 3)
   T5 = getband(data, 4) 

   T3new = tfix(t3, 3, /byte)
   T4new = tfix(t4, 4, /byte)
   T5new = tfix(t5, 5, /byte)

   putband, data, 2, t3new
   putband, data, 3, t4new
   putband, data, 4, t5new

   datacal = avhrrunscale(data, /byte, /ref)

   TMP = fltarr(100,100,12)
   for iband = 0,11 do  TMP(*,*,iband)=getband(datacal, iband)
   clavrone, TMP, clouds, jd, [0,0,0,0,0,0], 0, 0

   putband, data, 11, byte(clouds(*,*,0))

   imgwrite, data,goodpath+files(i)
   pcc =  n_elements(where(clouds(*,*,0) gt 0))/(100.)
   print, files(i), pcc,"%  ", jd
   if(pcc le 100.0) then $
     printf, 20,files(i), "  ", pcc, "%"

endfor
close,20

end
