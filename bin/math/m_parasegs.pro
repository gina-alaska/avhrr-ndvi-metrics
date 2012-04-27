FUNCTION m_ParaSegs, s1x1, s1y1, s1x2, s1y2, s2x1, s2y1, s2x2, s2y2, $
                   XIntPts, YIntPts, IntPtsC
;print, ''
;print, "****IN M_PARASEGS****"
;
; This routine checks for Parallel segments, or segments that cross 
; at an endpoint
;

@vectormath.h
rs=s1x1*0.

;
; Check First point of Line 1 on Segment 2
;
onseg =where (m_IsPointOnSeg (s1x1, s1y1, s2x1, s2y1, s2x2, s2y2),nonseg) 

;print, "P1 S1 on S2:",nonseg
IF (nonseg gt 0) THEN BEGIN

    Xtmp=XIntPts[onseg]
    Ytmp=YIntPts[onseg]
    Itmp=IntPtsC[onseg]

    rs[onseg] = M_AddIntPoint (s1x1[onseg], s1y1[onseg], $
                      Xtmp, Ytmp, Itmp)

    XIntPts[onseg]=Xtmp
    YIntPts[onseg]=Ytmp
    IntPtsC[onseg]=Itmp

END

;
; Check Second point of Line 1 on Segment 2
;
onseg =where (m_IsPointOnSeg (s1x2, s1y2, s2x1, s2y1, s2x2, s2y2),nonseg) 

;print, "P2 S1 on S2:",nonseg
IF (nonseg gt 0) THEN BEGIN

    Xtmp=XIntPts[onseg]
    Ytmp=YIntPts[onseg]
    Itmp=IntPtsC[onseg]

    rs[onseg] = M_AddIntPoint (s1x2[onseg], s1y2[onseg], $
                      Xtmp, Ytmp, Itmp)

    XIntPts[onseg]=Xtmp
    YIntPts[onseg]=Ytmp
    IntPtsC[onseg]=Itmp
END


;
; Check First point of Line 2 on Segment 1
;
onseg =where (m_IsPointOnSeg (s2x1, s2y1, s1x1, s1y1, s1x2, s1y2),nonseg) 

;print, "P1 S2 on S1:",nonseg
IF (nonseg gt 0) THEN BEGIN
    Xtmp=XIntPts[onseg]
    Ytmp=YIntPts[onseg]
    Itmp=IntPtsC[onseg]

    rs[onseg] = M_AddIntPoint (s2x1[onseg], s2y1[onseg], $
                      Xtmp, Ytmp, Itmp)

    XIntPts[onseg]=Xtmp
    YIntPts[onseg]=Ytmp
    IntPtsC[onseg]=Itmp
END

;
; Check Second point of Line 2 on Segment 1
;
onseg =where (m_IsPointOnSeg (s2x2, s2y2, s1x1, s1y1, s1x2, s1y2),nonseg) 

;print, "P2 S2 on S1:",nonseg
IF (nonseg gt 0) THEN BEGIN
    Xtmp=XIntPts[onseg]
    Ytmp=YIntPts[onseg]
    Itmp=IntPtsC[onseg]

    rs[onseg] = M_AddIntPoint (s2x2[onseg], s2y2[onseg], $
                      Xtmp, Ytmp, Itmp)

    XIntPts[onseg]=Xtmp
    YIntPts[onseg]=Ytmp
    IntPtsC[onseg]=Itmp
END



;print, "****EXIT M_PARASEGS****"
;print, ''
return, rs
;return, TRUE
END
