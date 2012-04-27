FUNCTION  rgctest, ndvi, jday, ndv, SCORE=score

;
; RRCT, reflectance ration cloud test: is ratio of ch2 to ch1 is near unity?
; (yes = cloud)
; (ACTUALLY THIS HAS BEEN REPLACED BY THE NDVI TEST

@dates.dat

t = interpol(ndv, dat, jday)
rr = ndvi
rrct = (rr lt t(0)) and (rr ge 0)

IF (KEYWORD_SET(score) eq 0) THEN $
   return, rr $
ELSE $
   return, rrct

end
