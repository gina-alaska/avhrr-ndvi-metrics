PRO addclouds, listfile

readlist, listfile, nim, path, file

tmp = intarr(512,512,11)

FOR i = 0, nim-1 DO BEGIN

   pathfile = path(0)+file(i)


   jd = file2jul(file(i), year=1996)
   data = imgread3(pathfile, 512,512,10, /i2)
   datau = avhrrunscale(data, /ref, /i2)
   clavr2, datau, clouds2, jd

   kernal = replicate(1., 3, 3)
   clouds = dilate(clouds2(*,*,0), kernal)
   tmp(*,*,0:9) = data
   tmp(*,*,10)  = fix(clouds)

   imgwrite, tmp, pathfile+".cld"
endfor

end

