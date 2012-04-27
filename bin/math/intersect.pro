;PRO  Intersect, P1, P2, R1, R2, XIntPts, YIntPts, IntPtsC
PRO  Intersect, s1x1, s1y1, s1x2, s1y2, $
                s2x1, s2y1, s2x2, s2y2,  XIntPts, YIntPts, IntPtsC

;
;  This function checks whether the line segments P1P2 and
;  R1R2 intersect.  P1, P2, R1 and R2 are (x,y) ordered
;  pairs.
;
;  The function uses the parametric equation of a line, ie
;  AX + BY + C = 0, where A^2 + B^2 = 1, rather than the
;  slope-intercept form of the line
;
;  Function returns:
;     0 - line segments do not intersect
;     1 - line segments intersect once
;     2 - line segments overlap
;
@vectormath.h
IntPtsC = 0

;s1x1 = double(P1(0))
;s1x2 = double(P2(0))
;s1y1 = double(P1(1))
;s1y2 = double(P2(1))

;s2x1 = double(R1(0))
;s2x2 = double(R2(0))
;s2y1 = double(R1(1))
;s2y2 = double(R2(1))

s1x = s1x2 - s1x1
s1y = s1y2 - s1y1
s2x = s2x2 - s2x1
s2y = s2y2 - s2y1
s3x = s2x1 - s1x1
s3y = s2y1 - s1y1

det = (s2x * s1y) - (s2y * s1x)

IF (ABS(det) lt EPSILON) THEN $

    status=ParaSegs( s1x1, s1y1, s1x2, s1y2, s2x1, s2y1,$
                     s2x2, s2y2, XIntPts, YIntPts, IntPtsC)  $
ELSE BEGIN

    InvDet = 1.0/det

    s = ((s2x * s3y) - (s2y * s3x)) * invdet

    IF (( s ge 0 ) AND (s LE 1.0)) THEN BEGIN

      t = ((s1x * s3y) - (s1y * s3x)) * invdet

      IF (( t GE 0.0 )  AND ( t LE 1.0 )) THEN BEGIN
      
         x = s1x1 + (s1x * s)
         y = s1y1 + (s1y * s)
  
         status = AddIntPoint( x, y, XIntPts, YIntPts, IntPtsC )
      ENDIF
    ENDIF
ENDELSE

END

