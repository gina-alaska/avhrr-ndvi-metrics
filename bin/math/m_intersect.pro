PRO  M_Intersect, s1x1, s1y1, s1x2, s1y2, $
                s2x1, s2y1, s2x2, s2y2,  $
                XIntPts, YIntPts, IntPtsC
;print, "****IN M_INTERSECT****"

;
;  This function checks whether the line segments P1P2 and
;  R1R2 intersect.  P1, P2, R1 and R2 are (x,y) ordered
;  pairs.
;
;  The function uses the parametric equation of a line, ie
;  AX + BY + C = 0, where A^2 + B^2 = 1, rather than the
;  slope-intercept form of the line
;
;  Function returns in IntPtsC:
;     0 - line segments do not intersect
;     1 - line segments intersect once
;     2 - line segments overlap
;

@vectormath.h

;
; Get size of input data
;
   Size_X=size(s1x1)

;   Size_X[n_elements(Size_x)-1] = 2   ; make output integer

;
; Make space for output
;
   Status=Make_Array(Size=Size_X)*0
   IntPtsC=Make_Array(Size=Size_X)*0
   XIntPts=Make_Array(Size=Size_X)*0
   YIntPts=Make_Array(Size=Size_X)*0
   s=Make_Array(Size=Size_X)
   t=Make_Array(Size=Size_X)
   x=Make_Array(Size=Size_X)
   y=Make_Array(Size=Size_X)

;
; Get line segment lengths
;
   s1x = s1x2 - s1x1
   s1y = s1y2 - s1y1
   s2x = s2x2 - s2x1
   s2y = s2y2 - s2y1
   s3x = s2x1 - s1x1
   s3y = s2y1 - s1y1

;
; Get determinant between line segments
;
   det = (s2x * s1y) - (s2y * s1x)
   invdet=det*0




;
; Deal with points where determinant is ZERO
;
   det0_idx = where (ABS(det) lt EPSILON, ndet0_idx) 
   ii=det0_idx

   IF(ndet0_idx gt 0) THEN BEGIN

;print, 'DETERMINANT IS ZERO', ndet0_idx

      xtmp=XintPts[ii]
      ytmp=YintPts[ii]
      itmp=IntPtsC[ii]

      Status[ii]=M_ParaSegs(s1x1[ii], s1y1[ii], s1x2[ii], s1y2[ii], $
                          s2x1[ii], s2y1[ii], s2x2[ii], s2y2[ii], $
                          Xtmp, Ytmp, Itmp) 
      XIntPts[ii]=Xtmp
      YIntPts[ii]=Ytmp
      IntPtsC[ii]=Itmp

   ENDIF ; ZERO DETERMINANT




;
; Deal with points where determinant is NOT ZERO
;
   detn0_idx = where(ABS(det) ge EPSILON, ndetn0_idx)
   jj=detn0_idx

   IF (ndetn0_idx gt 0) THEN BEGIN

;print, 'DETERMINANT NOT ZERO', ndetn0_idx

      InvDet[jj] = 1.0/det[jj]

      s[jj] = ((s2x[jj] * s3y[jj]) - (s2y[jj] * s3x[jj])) * invdet[jj]
      t[jj] = ((s1x[jj] * s3y[jj]) - (s1y[jj] * s3x[jj])) * invdet[jj]

      inr=where(s[jj] ge 0 AND s[jj] le 1.0 AND $
                t[jj] ge 0 AND t[jj] le 1.0, ninr)


;
; These are cases where the lines intersect
;
      IF (ninr gt 0) then BEGIN

         x[jj[inr]] = s1x1[jj[inr]] + (s1x[jj[inr]] * s[jj[inr]])
         y[jj[inr]] = s1y1[jj[inr]] + (s1y[jj[inr]] * s[jj[inr]])
  
         xinttmp=XIntPts[jj[inr]]
         yinttmp=YIntPts[jj[inr]]
         inttmp=IntPtsC[jj[inr]]

         Status[jj[inr]] = M_AddIntPoint( x[jj[inr]], y[jj[inr]], $
                      XInttmp, YInttmp, Inttmp )
         
         XIntPts[jj[inr]]=xinttmp
         YIntPts[jj[inr]]=yinttmp         
         IntPtsC[jj[inr]]=inttmp         

;print, "Post NZ ADD",total(status), total(intptsc)

      ENDIF ; ninr gt 0
   ENDIF ; ndetn0_idx gt 0

;PRINT, "****END M_INTERSECT****"
;die
END

