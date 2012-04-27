FUNCTION WarmEdge, T, ND, Percent, XBin=XBin

;
;  This function fits a 2nd order curve to the warm edge of
;  the NDVI vs T space.  This is done to help come up with
;  a value for Tmax to be used in the normalization of the
;  space.
;
;  ND and T have already been multiplied by a 1-bit cloud
;  mask. 
;

CASE (KEYWORD_SET(XBin)) OF
  0: XBin = 1.0
  1: XBin = XBin
  ELSE:
ENDCASE

NotZero = where (T gt 0)
TMin = Floor(Min(T(NotZero)))
TMax = Ceil(Max(T(NotZero)))

nTBins = (TMax - TMin)/XBin
TmpDataToFit = fltarr(2,nTBins)

Counter = 0
FOR iT = 0, nTBins-1  DO BEGIN
   
   TLo = TMin + iT*XBin
   THi = TMin + (iT+1)*XBin
 
   TBinIdx = where( T ge TLo and T lt THi, nTIdx)

   if(nTIdx gt 0) THEN BEGIN
      NDBin = ND(TBinIdx)
      NDSort = NDBin(Sort(NDBin))

      TmpDataToFit(0, Counter) = Avg([TLo, THi])
      TmpDataToFit(1,Counter) = $
        Avg(NDSort(floor(Percent*NTIdx/100.):N_Elements(NDSort)-1)) 
 
      Counter = Counter + 1
   ENDIF

ENDFOR
DataToFit = fltarr(2, Counter)

DataToFit = TmpDataToFit(*, 0:Counter-1)

RETURN, DataToFit

END 
