FUNCTION  AddIntPoint, x, y, XIntPts, YIntPts, IntPtsC

@vectormath.h

status = FALSE
duplicate = FALSE

IF (IntPtsC EQ 0) THEN BEGIN

   XIntPts = x
   YIntPts = y
   IntPtsC = IntPtsC + 1
 
   status =  TRUE

ENDIF ELSE IF (IntPtsC gt 0) THEN BEGIN

   FOR j = 0, IntPtsC - 1  DO BEGIN

      IF (( ABS(x - XIntPts) LE EPSILON ) AND $
          ( ABS(y - YIntPts) LE EPSILON ) ) THEN BEGIN

         duplicate = TRUE
         status = TRUE
      ENDIF
   ENDFOR

   IF ( NOT duplicate ) THEN BEGIN
 
      IF ((IntPtsC + 1) LE INT_PTS_MAX ) THEN BEGIN
         XIntPts = x
         YIntPts = y
         IntPtsC = IntPtsC + 1 
         status = TRUE
      ENDIF
   ENDIF
ENDIF ELSE BEGIN
   status = FALSE
ENDELSE

RETURN, status

END
