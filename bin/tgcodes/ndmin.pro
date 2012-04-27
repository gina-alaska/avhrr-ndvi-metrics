PRO NDMin, ND, T, AvgND

;
;  This function fits estimates the "minimum" vegetated ndvi       
;  for a scene. 
;
;  ND and T have already been multiplied by a 1-bit cloud
;  mask. 
;

DelT = 1.0
Percent = 0.05

NotZero = where (T gt 0)
TMin = Floor(Min(T(NotZero)))
TMax = Ceil(Max(T(NotZero)))

nTBins = (TMax - TMin)/DelT
AvgND = fltarr(2,nTBins)


FOR iT = 0, nTBins-1  DO BEGIN
   
   TLo = TMin + iT*DelT
   THi = TMin + (iT+1)*DelT
 
   TBinIdx = where( T ge TLo and T lt THi, nTIdx)

   NDBin = ND(TBinIdx)

   NDSort = NDBin(Sort(NDBin))

   AvgND(0, iT) = Avg([TLo, THi])
   AvgND(1,iT) = Avg(NDSort(0:ceil(Percent*NTIdx))) 
 
print, AvgND(0, iT), AvgND(1,iT)

ENDFOR
END 
