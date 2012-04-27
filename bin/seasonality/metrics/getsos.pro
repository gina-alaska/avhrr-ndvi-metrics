FUNCTION  GetSOS, Cross, NDVI, x, bpy, FMA

;
; NOTE: I still need to do something in case it doesn't find a first sos
;

;
; Calculations for slope method
;
      nFMA=n_elements(FMA)
      FSlope=fltarr(nFMA-1)
      For i = 0, nFMA-2 DO $
         FSlope[i]=FMA[i+1]-FMA[i]

      nNDVI=n_elements(NDVI)
      NSlope=fltarr(nNDVI-1)
      For i = 0, nNDVI-2 DO $
         NSlope[i]=NDVI[i+1]-NDVI[i]



      ny=N_Elements(NDVI)/bpy
      SOST=fltarr(ny)
      SOSN=fltarr(ny)

;
; First SOS must be within first bpy
;
      FirstIdx=where(Cross.X LT bpy, nFirstSOS)

;
; Slope Method
;
      FirstSOSIdx=where(NDVI[fix(Cross.x[firstidx])] eq $
                    min(NDVI[fix(Cross.x[firstidx])]))

;
; Slope Method
;
;      FirstSOSIdx=where(NSlope[fix(Cross.x[firstidx])]-FSlope[fix(Cross.x[firstidx])] eq $
;                    max(NSlope[fix(Cross.x[firstidx])]-FSlope[fix(Cross.x[firstidx])]))

;
; Max ND Change Method
;
;      FirstSOSIdx=where(NDVI[fix(Cross.x[firstidx]+1)]-NDVI[fix(Cross.x[firstidx])] eq $
;                    max(NDVI[fix(Cross.x[firstidx]+1)]-NDVI[fix(Cross.x[firstidx])]))

      FirstSOST=Cross.x[FirstIdx[FirstSOSIdx[0]]]
      FirstSOSN=Cross.Y[FirstIdx[FirstSOSIdx[0]]]

      CURX=FirstSOST

      SOST[0]=FirstSOST
      SOSN[0]=FirstSOSN

;
; From first SOS, go at least half year, not more than 1.5 years
;
      FOR i = 1, ny-1 DO BEGIN

         NextIdx=where(Cross.X GT CurX+bpy*0.75 and Cross.X LT CURX+1.25*bpy, nNext)

         IF (nNext gt 0) THEN BEGIN

;
; Min ND Method
;
         NextSOSIdx=where(NDVI[fix(Cross.x[NextIdx])] eq $
                      min(NDVI[fix(Cross.x[NextIdx])]))

;
; Slope Method
;
;         NextSOSIdx=where(NSlope[fix(Cross.x[NextIdx])]-FSlope[fix(Cross.x[NextIdx])] eq $
;                      max(NSlope[fix(Cross.x[NextIdx])]-FSlope[fix(Cross.x[NextIdx])]))

;
; Max ND Change Method
;
;            NextSOSIdx=where(NDVI[Cross.x[NextIdx]+1]-NDVI[Cross.x[NextIdx]] eq $
;                         max(NDVI[Cross.x[NextIdx]+1]-NDVI[Cross.x[NextIdx]]))




         SOST[i]=Cross.x[NextIdx[NextSOSIdx[0]]]
         SOSN[i]=Cross.Y[NextIdx[NextSOSIdx[0]]]
         CURX=SOST[i]

      END ELSE CURX=CURX+bpy

   END;FOR 

   SOST=rmzeros(sost, /trail)
   SOSN=rmzeros(sosn, /trail)

   SOS={SOST:SOST, SOSN:SOSN}

;print, 'SOS:'
;print, sos.sost

RETURN, SOS
END
