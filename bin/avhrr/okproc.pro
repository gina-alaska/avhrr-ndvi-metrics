PRO  okproc, listfile

dim=512
nbands=10
classimg = "/sg1/sab1/suarezm/rad/tgclass/okclass.img"

readlist, listfile, nim, path, file

FOR i = 0, nim-1 DO BEGIN

   jd = file2jul(file(i), year = 1996)
   pathfile = path(0)+file(i)

   data = imgread(pathfile,dim,dim,nbands,/i2, /order)
   datau = avhrrunscale(data, /i2, /ref)

   class = imgread(classimg,dim,dim,1, /order)

   clavr, datau, clouds, jd, dim, [0,0,0,0,0,0],0,0

   wwidx = where(class eq 9 or class eq 4)
   wwmask = mask(class, wwidx, /hide)

   bgidx = where(class eq 80)
   bgmask = mask(class, bgidx, /hide)

;hotcloud = where(getband(datau, 3, 512) gt 300 and clouds[*,*,0] gt 0)
;print, "HOTCLOUD#: ",n_element(hotcloud) 

   cmask = clouds[*,*,1]*wwmask + $
           clouds[*,*,2]*wwmask + $
           clouds[*,*,3]+$;*wwmask + $
           clouds[*,*,4] + $
           clouds[*,*,5] 
   

   nclouds = float(n_elements(where(clouds[*,*,0] eq 0)))
   ncmask = float(n_elements(where(cmask eq 0)))

   print, file(i),nclouds/dim/dim*100, ncmask/dim/dim*100

ENDFOR

END 
