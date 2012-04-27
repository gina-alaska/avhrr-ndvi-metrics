FUNCTION  GetEOS, Cross, NDVI, x, bpy, SOS

nSOS=N_Elements(SOS.SOST)
nNDVI=N_Elements(NDVI)

   
   EOST=FltArr(nSOS)
   EOSN=FltArr(nSOS)

;print, "GETEOS"
   CurX=0
   FOR i = 0, nSOS-1 DO BEGIN

      IF ((SOS.SOST[i] ne 0) or ( i eq 0 and SOS.SOST[i] eq 0)) then $
         CurX=SOS.SOST[i] $
      ELSE $
         CurX=CurX+bpy

      NextIdx=where(Cross.X GT CurX and Cross.X LT CurX+bpy AND Cross.X LT nNDVI-2, nNext)

      IF (nNext gt 0) THEN BEGIN

         NextEOSIdx=where(NDVI[fix(Cross.x[NextIdx])] eq $
                      min(NDVI[fix(Cross.x[NextIdx])]))

;         NextEOSIdx=where(NDVI[fix(Cross.x[NextIdx]+1)]-NDVI[fix(Cross.x[NextIdx])] eq $
;                      min(NDVI[fix(Cross.x[NextIdx]+1)]-NDVI[fix(Cross.x[NextIdx])]))

         EOST[i]=Cross.x[NextIdx[NextEOSIdx[0]]]
         EOSN[i]=Cross.Y[NextIdx[NextEOSIdx[0]]]

      END;IF

      
   END;FOR 

   IF (EOST[nSOS-1] EQ 0) then  EOST[nSOS-1]=nNDVI-1
   IF (EOSN[nSOS-1] EQ 0) then  EOSN[nSOS-1]=NDVI[nNDVI-1]

EOST=rmzeros(eost, /trail)
EOSN=rmzeros(eosn, /trail)

   EOS={EOST:EOST, EOSN:EOSN}

;print, 'EOS:'
;print, eos.eost

RETURN, EOS
END
