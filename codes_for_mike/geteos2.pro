FUNCTION  GetEOS2, Cross, NDVI, x, bpy, SOS

FILL=-1.


; Define window following SOS in which to look for EOS
; (factor of bpy)
   WinMin=0.25
   WinMax=1.1

   nSize=Size(NDVI)
   nNDVI=nSize[nSize[0]]
   ny=nSize[nSize[0]]/bpy
   nSOS=N_Elements(SOS.SOST)
   


   CASE (nSize[0]) OF

      1: BEGIN
         EOST=FltArr(nSOS)+FILL
         EOSN=FltArr(nSOS)+FILL

         CurX=0

         FOR i = 0, nSOS-1 DO BEGIN

            IF ((SOS.SOST[i] ne FILL) or ( i eq 0 and SOS.SOST[i] eq 0)) then $
               CurX=SOS.SOST[i] $
            ELSE $
               CurX=CurX+bpy
      
            NextIdx=where(Cross.X GT CurX+WinMin*bpy AND $
                          Cross.X LT CurX+WinMax*bpy AND $
                          Cross.X LT nNDVI-2, nNext)

            IF (nNext gt 0) THEN BEGIN
      
;               NextEOSIdx=where(NDVI[fix(Cross.x[NextIdx])] eq $
;                            min(NDVI[fix(Cross.x[NextIdx])]))
               NextEOSIdx=where(Cross.y[NextIdx] eq $
                            min(Cross.y[NextIdx]))
      
      
               EOST[i]=Cross.x[NextIdx[NextEOSIdx[0]]]
               EOSN[i]=Cross.Y[NextIdx[NextEOSIdx[0]]]
      
            END;IF
      
            
         END;FOR 
      
;         IF (EOST[nSOS-1] EQ 0) then  EOST[nSOS-1]=nNDVI-1
;         IF (EOSN[nSOS-1] EQ 0) then  EOSN[nSOS-1]=NDVI[nNDVI-1]
      
;         EOST=rmzeros(eost, /trail)
;         EOSN=rmzeros(eosn, /trail)
      
         EOS={EOST:EOST, EOSN:EOSN}

      END;nSize[0]=1


      3: BEGIN

         EOST=Make_Array(Size=Size(SOS.SOST))+FILL
         EOSN=Make_Array(Size=Size(SOS.SOSN))+FILL

;         EOST[*,*,ny-1]=float(nNDVI)-1
;         EOSN[*,*,ny-1]=NDVI[*,*,nNDVI-1]

         CurX=fltarr(nSize[1],nSize[2])
     
               FOR k = 0, ny-1 DO BEGIN ;MJS 8/4/98 changed nSOS to ny
            FOR j = 0, nSize[2]-1 DO BEGIN 

         FOR i = 0, nSize[1]-1 DO BEGIN 

                   IF ((SOS.SOST[i,j,k] ne 0) or ( k eq 0 and SOS.SOST[i,j,k] eq 0)) then $
                      CurX[i,j]=SOS.SOST[i,j,k] $
                   ELSE $
                      CurX[i,j]=CurX[i,j]+bpy
       
                   NextIdx=where(Cross.X[i,j,*] GT CurX[i,j]+WinMin*bpy AND $
                                 Cross.X[i,j,*] LT CurX[i,j]+WinMax*bpy AND $
                                 Cross.X[i,j,*] LT nNDVI-2, nNext)
       
                   IF (nNext gt 0) THEN BEGIN
       
;                      NextEOSIdx=where(NDVI[fix(Cross.x[i,j,NextIdx])] eq $
;                                   min(NDVI[fix(Cross.x[i,j,NextIdx])]))
                      NextEOSIdx=where(Cross.y[i,j,NextIdx] eq $
                                   min(Cross.y[i,j,NextIdx]))
       
       
                      EOST[i,j,k]=Cross.x[i,j,NextIdx[NextEOSIdx[0]]]
                      EOSN[i,j,k]=Cross.Y[i,j,NextIdx[NextEOSIdx[0]]]

                  END;IF

         EOS={EOST:EOST, EOSN:EOSN}

               END; k
            END; j
         END; i

      END;nSize[0]=3
      ELSE:
   ENDCASE


RETURN, EOS
END
