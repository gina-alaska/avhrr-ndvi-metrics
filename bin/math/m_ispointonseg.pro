FUNCTION m_IsPointOnSeg, x0, y0, x1, y1, x2, y2
@vectormath.h

   size_x0=size(x0)
   size_x0[n_elements(size_x0)-3] = 1

   status=Make_Array(Size=size_x0)
   status = status*FALSE
   EPSILON= status+EPSILON


;
;  line segment is degenerate
;
   degen_idx = where((ABS(x2 - x1) LE EPSILON) AND (ABS(y2 - y1) LE EPSILON) $
                 AND (ABS(x1 - x0) LE EPSILON) AND (ABS (y1 - y0) LE EPSILON),$
                 ndegen)

   IF (ndegen GT 0) THEN Status[degen_idx] = TRUE



;
;  line segment is vertical
;
   vert_idx = where((ABS (x2 - x1) LT EPSILON) AND $
       (ABS (x1 - x0) LT EPSILON)           AND $
       (y0 GE ( (y1 < y2) - EPSILON))   AND $
       (y0 LE ( (y1 > y2) + EPSILON)), nvert)

   IF (nvert GT 0) THEN Status[vert_idx] = TRUE


;
;  line segment is horizontal
;
   hor_idx = where((ABS (y2 - y1) LT EPSILON) AND $
                (ABS (y1 - y0) LT EPSILON) AND $
       (x0 GE ((x1 < x2) - EPSILON))  AND $
       (x0 LE ((x1 > x2) + EPSILON)), nhor)
 
   IF (nhor GT 0) THEN Status[hor_idx] = TRUE


;
;  line segment is oblique
;

    y_intercept = y1 + (((y2 - y1) / (x2 - x1)) * (x0 - x1));
    obl_idx = where ((ABS (y_intercept - y0) LT EPSILON) AND $
        (x0 GE ((x1 < x2) - EPSILON))    AND $
        (x0 LE ((x1 > x2) + EPSILON))    AND $
        (y0 GE ((y1 < y2) - EPSILON))    AND $
        (y0 LE ((y1 > y2) + EPSILON)), nobl)
    
    IF (nobl GT 0) THEN Status[obl_idx] = TRUE
   

return, status

END
