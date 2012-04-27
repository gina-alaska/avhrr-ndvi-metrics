;
;  This function returns only a mask of ones and zeros
;  Keywords are set to either SHOW or HIDE the values
;  in the array elements idx of data.  SHOW puts 1's
;  in the IDX elements and 0's everywhere else; HIDE
;  puts 0's in IDX and 1's everywhere else.
;  The array, Data is only used to size the mask.
;

FUNCTION  Mask, Data, Idx, SHOW=show, HIDE=hide


DataSize = Size(Data)

NSamps = DataSize(1)
NLines = DataSize(2)

Tmp = BytArr(NSamps, NLines)

IF (KEYWORD_SET(SHOW)) THEN BEGIN
   Tmp(idx) = 1
ENDIF ELSE IF (KEYWORD_SET(HIDE)) THEN BEGIN
   Tmp = Tmp + 1
   Tmp(idx) = 0
ENDIF ELSE BEGIN
   Tmp = Data*0+1
ENDELSE

RETURN, Tmp

END
