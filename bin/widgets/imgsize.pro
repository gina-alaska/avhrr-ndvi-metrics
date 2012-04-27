;###########################################################################
; File Name:  %M%
; Version:    %I%
; Author:     Mike Schienle
;             updated byt Manuel Suarez to do NSamp x NLine x NBand
; Orig Date:  97-06-10  / 97-07-17 MJS
; Delta Date: %G% @ %U%
;###########################################################################
; Purpose: Create a list of possible X/Y dimensions based on input size.
; History: 
;###########################################################################
; %W%
;###########################################################################

FUNCTION ImgSize, lSize

b=''

;   Limit the number of bands from 1 to 16
    FOR iBand = 1, 16 DO BEGIN
        IF (lSize MOD iband EQ 0) THEN BEGIN 
           lSizeTmp = lSize/iBand

	   ;	get the Square Root of the input value
	   lSqRt = Long(SqRt(lSizeTmp))

	   ;	use 4:1 as limits of X:Y ratio
	   lDiv2 = lSqRt / 2
	
           ;	creat a floating point index array of values in possible range
	   afIndex = FIndGen(lDiv2 + 1) + lDiv2
	
	   ;	divide input size by possible values
	   afDiv = lSizeTmp / afIndex
	
	   ;	get an integer version of previous division
	   alDiv = Long(afDiv)
	
	   ;	determine where integer and float are equal
	   aPos = Where(afDiv EQ alDiv, lPos)
	
	   ;	determine if any values matched
	   IF (lPos GT 0) THEN BEGIN
		; check if final value is the square root of the size
		IF ((alDiv[aPos[lPos - 1]] ^ 2L) EQ lSizeTmp) THEN $
			;   use one less element in array to avoid duplicates
			lOffset = 1L $
	      	ELSE $
			;	full size array
			lOffset = 0L
		
		;	create the output array
		aSize = LonArr(3, lPos * 2L - lOffset, /NoZero)

		;	fill in the top portion of the X values
		aSize[0, 0:lPos - 1] = alDiv[aPos]
		;	bottom portion of the X values
		;	possible recalc of square root value may occur - no harm
		aSize[0, lPos - lOffset:*] = Reverse(lSizeTmp / alDiv[aPos])
		
		;	fill in the Y values
		aSize[1, *] = Reverse(aSize[0, *], 2)
                aSize[2, *] = aSize[2,*]*0 + iBand

IF (iBand EQ 1) THEN BEGIN
   bSize = aSize
ENDIF ELSE BEGIN
   bSize = [[bSize], [aSize]]
ENDELSE
	   ENDIF ELSE BEGIN
		;	input value is "prime" between SqRt(lSizeTmp) / 2 
                ;       and SqRt(lSizeTmp)
		aSize = -1
      	   ENDELSE

        ENDIF ELSE BEGIN
		;	input value is "prime" for range of iBand
                aSize = -1	
        ENDELSE 




    ENDFOR
;    Return, aSize
    Return, bSize
end
