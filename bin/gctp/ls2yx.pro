FUNCTION  ls2yx, l, s, UL, PixSize

X = UL[1]+s*PixSize[1]
Y = UL[0]-L*PixSize[0]

Return, {y:y, x:x}
END
