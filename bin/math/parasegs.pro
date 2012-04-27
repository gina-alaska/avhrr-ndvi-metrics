FUNCTION ParaSegs, s1x1, s1y1, s1x2, s1y2, s2x1, s2y1, s2x2, s2y2, $
                   XIntPts, YIntPts, IntPtsC
@vectormath.h

IF (IsPointOnSeg (s1x1, s1y1, s2x1, s2y1, s2x2, s2y2)) THEN $
    rs = addintpoint (s1x1, s1y1, XIntPts,YIntPts, IntPtsC)

IF (IsPointOnSeg (s1x2, s1y2, s2x1, s2y1, s2x2, s2y2)) THEN $
    rs = addintpoint (s1x2, s1y2, XIntPts,YIntPts, IntPtsC)

IF  (IsPointOnSeg (s2x1, s2y1, s1x1, s1y1, s1x2, s1y2)) THEN $
    rs = addintpoint (s2x1, s2y1, XIntPts,YIntPts, IntPtsC)

IF (IsPointOnSeg (s2x2, s2y2, s1x1, s1y1, s1x2, s1y2)) THEN $
    rs = addintpoint (s2x2, s2y2, XIntPts,YIntPts, IntPtsC)

return, TRUE
END
