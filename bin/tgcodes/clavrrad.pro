FUNCTION  clavrrad, data, jd, satnum

;
;  This routine is used when the input data from bands 1, 2 and NDVI
;  are in/from radiance rather than reflectance.  It first converts
;  radiance to reflectance, then radiance NDVI to reflectance NDVI.
;  It then calls the function CLAVR, which is the same as CLAVRONE
;  with the sole exception that it can handle images of any size.
;

dim = n_elements(data(*,0))
nbands = n_elements(data(0,*))/dim

datanew = data

Rad1 = getband(data, 0, dim)
Rad2 = getband(data, 1, dim)

SolZen = getband(data, 7, dim) / 10.0

Ref1 = Rad2Ref(Rad1, 1, SolZen, jd) 
Ref2 = Rad2Ref(Rad2, 2, SolZen, jd) 

NDVI = F_NDVI(Ref1, Ref2)

PutBand, datanew, 0, Ref1, dim 
PutBand, datanew, 1, Ref2, dim 
PutBand, datanew, 5, nd2i(NDVI), dim 

Tmp = fltarr(dim, dim, nbands)
FOR iband = 0, nbands-1 DO Tmp(*,*,iband) = getband(datanew, iband, dim)
clavr, TMP, clouds, jd, dim, [0,0,0,0,0,0], 0, 0

return, clouds
end
