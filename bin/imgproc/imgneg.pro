FUNCTION ImgNeg, BinImage

;  This takes an image of zeros and ones (a mask) and
;  inverses it.

dmin = min(BinImage)
dmax = max(BinImage)


RETURN, dmax - BinImage + dmin 

END
