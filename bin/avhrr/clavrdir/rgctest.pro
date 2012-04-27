FUNCTION  rgctest, band1, jday, red, SCORE=score

;
;  RGCT, reflectance gross cloud test; is channel 1 reflectance > t
;
@dates.dat

t = interpol(red, dat, jday)
rgc = band1
rgct = (rgc gt t(0))
shad1 = rgc lt t(0)/2.

IF (KEYWORD_SET(score) eq 0) THEN $
   return, rgc $
ELSE $
   return, rgct

end
