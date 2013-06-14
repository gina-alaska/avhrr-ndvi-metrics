;jzhu, 8/1/2011. THis program modified from GetEOS2.prom GetEOS2.pro picks the END of Season by thinking EOS occurs at where the NDVI is minimum. 
;This program choose the point where slope of NDVI is smallest.

FUNCTION  GetEOS3, Cross, NDVI, x, bpy,SOS,bma

FILL=-1.

;
; Calculation the slope of ndvi and fma for slope method
;
      nbMA=n_elements(bMA)
      bSlope=fltarr(nbMA-1)
      For i = 0, nbMA-2 DO $
         bSlope[i]=bMA[i+1]-bMA[i]

      nNDVI=n_elements(NDVI)
      NSlope=fltarr(nNDVI-1)
      For i = 0, nNDVI-2 DO $
         NSlope[i]=NDVI[i+1]-NDVI[i]


      ny=N_Elements(NDVI)/bpy
      SOST=fltarr(ny)
      SOSN=fltarr(ny)


; Define window following SOS in which to look for EOS
; (factor of bpy)
   WinMin=0.25
   WinMax=1.0

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
;                          
;            NextIdx=where(Cross.X GT CurX AND $
;                          Cross.X LT CurX+WinMax*bpy AND $
;                          Cross.X LT nNDVI-2, nNext)



            IF (nNext gt 0) THEN BEGIN

    
;               possi_NextEOSIdx=where(NDVI[fix(Cross.x[NextIdx])] eq $
;                            min(NDVI[fix(Cross.x[NextIdx])]))

;
; minimun ndvi method, this method is used in geteod2.pro

;               psble1_NextEOSIdx=where(Cross.y[NextIdx] eq $
;                            min(Cross.y[NextIdx]))


 
;GetEOS3.pro method, slope method, jzhu, 8/10/2011-------------------
               
;----minimun slope method -------------

;               slope=fltarr(nNEXT)
               
;               slope[NextIdx]= NDVI[fix(Cross.x[NextIdx])]-NDVI[fix(Cross.x[NextIdx])-1]

;               psble2_NextEOSIdx=where(slope EQ min(slope[NextIdx]) )




;slope difference method
         
      psble_NextEOSIdx=where(NSlope[fix(Cross.x[Nextidx])]-bSlope[fix(Cross.x[Nextidx])] eq $
                    min(NSlope[fix(Cross.x[Nextidx])]-bSlope[fix(Cross.x[Nextidx])]))

;
; Max ND Change Method, if you want this method, you need modify the following segement program
;
;      FirstSOSIdx=where(NDVI[fix(Cross.x[firstidx]+1)]-NDVI[fix(Cross.x[firstidx])] eq $
;                    max(NDVI[fix(Cross.x[firstidx]+1)]-NDVI[fix(Cross.x[firstidx])]))


;--------------------------------------------------------------------
               NExtEOSIdx=psble_NextEOSIdx               

              

      
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
