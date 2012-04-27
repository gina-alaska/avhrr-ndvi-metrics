FUNCTION IsPointOnSeg, x0, y0, x1, y1, x2, y2
@vectormath.h

status = FALSE

IF ( (ABS(x2 - x1) LE EPSILON) AND (ABS(y2 - y1) LE EPSILON) ) THEN BEGIN

;  line segment is degenerate

   IF ( (ABS(x1 - x0) LE EPSILON) AND (ABS (y1 - y0) LE EPSILON)) THEN BEGIN
      status = TRUE
   ENDIF

ENDIF ELSE IF (ABS (x2 - x1) LT EPSILON) THEN BEGIN

;  line segment is vertical

   IF ((ABS (x1 - x0) LT EPSILON)         AND $
       (y0 GE (MIN ([y1, y2]) - EPSILON))   AND $
       (y0 LE (MAX ([y1, y2]) + EPSILON))) THEN BEGIN
          status = TRUE
   ENDIF
 
ENDIF ELSE IF (ABS (y2 - y1) LT EPSILON) THEN BEGIN

;  line segment is horizontal

   IF ((ABS (y1 - y0) LT EPSILON)        AND $
       (x0 GE (MIN ([x1, x2]) - EPSILON))  AND $
       (x0 LE (MAX ([x1, x2]) + EPSILON)))  THEN BEGIN
          status = TRUE
   ENDIF 

ENDIF ELSE BEGIN

;  line segment is oblique

    y_intercept = y1 + (((y2 - y1) / (x2 - x1)) * (x0 - x1));
    IF ((ABS (y_intercept - y0) LT EPSILON) AND $
        (x0 GE (MIN ([x1, x2]) - EPSILON))    AND $
        (x0 LE (MAX ([x1, x2]) + EPSILON))    AND $
        (y0 GE (MIN ([y1, y2]) - EPSILON))    AND $
        (y0 LE (MAX ([y1, y2]) + EPSILON)))  THEN BEGIN
    
      status = TRUE
   
    ENDIF 

ENDELSE

  return, status

END
