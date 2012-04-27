;
;  This code was designed to convert the 1996 N)AA-14 Oklahoma
;  512x512 data from radiance to reflectance in bands 1, 2 and
;  the NDVI band
;  
;  This single input parameter is the listfile name
;
PRO ok2ref, listfile

readlist, listfile, nim, path, files

outpath = '/'

dirs = str_sep(path(0), '/')
ndirs=n_elements(dirs)

FOR i =1, ndirs-3 DO BEGIN
  outpath=outpath+dirs(i)+'/'
ENDFOR

outpath=outpath+'reflectance/'

 
FOR i = 0, nim-1 DO BEGIN

   pathfile = path(0)+files(i)

   print, "READING FILE: ", files(i)
   data = imgread(pathfile, 512,512,10, /i2)

   rad1 = i2rad(getband(data, 0, 512))
   rad2 = i2rad(getband(data, 1, 512))
   SolZen=i2SolZ(getband(data,7, 512))
   
   jd = file2jul(files(0), YEAR=1996)

   ref1=(rad2ref(rad1, 1, SolZen, jd))
   ref2=(rad2ref(rad2, 2, SolZen, jd))
   ndvi = nd2i(f_ndvi(ref1, ref2))

   dataref=data
   putband, dataref, 0, ref2i(ref1), 512
   putband, dataref, 1, ref2i(ref2), 512
   putband, dataref, 5, ndvi, 512

   print, "WRITING FILE: ", files(i)
   imgwrite, dataref, outpath+files(i)


ENDFOR
END
