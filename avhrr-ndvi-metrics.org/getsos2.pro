FUNCTION  GetSOS2, Cross, NDVI, x, bpy, FMA
;
; These numbers are the window (*bpy) from the
; current SOS in which to look for the next SOS
;
FILL=-1.
WinFirst=1.0
WinMin=0.5
WinMax=1.5

;
; NOTE: I still need to do something in case it doesn't find a first sos
;

      nSize=Size(NDVI)
      ny=nSize[nSize[0]]/bpy + (nSize[nSize[0]] mod bpy gt 0)

   CASE (nSize[0]) OF

      1: BEGIN
         SOST=fltarr(ny)+FILL
         SOSN=fltarr(ny)+FILL
;
; First SOS must be within first WinFirst*bpy
;
         FirstIdx=where(Cross.X LT WinFirst*bpy, nFirstSOS)
         if firstidx[0] EQ -1 then firstidx=0

;
; Min ND Method
;
         if(nFirstSOS gt 0) THEN  BEGIN
            FirstSOSIdx=where(Cross.y[firstidx] eq $
                          min(Cross.y[firstidx]))


            FirstSOST=Cross.x[FirstIdx[FirstSOSIdx[0]]]
            FirstSOSN=Cross.Y[FirstIdx[FirstSOSIdx[0]]]
         end else begin
            FirstSOST=0
            FirstSOSN=0
         end

         CurX=FirstSOST

IF FirstSOST LT bpy THEN BEGIN
         SOST[0]=FirstSOST
         SOSN[0]=FirstSOSN
         istart=1
END ELSE BEGIN
         SOST[0]=FILL
         SOSN[0]=FILL
         SOST[1]=FirstSOST
         SOSN[1]=FirstSOSN
         istart=2
END

;
; From first SOS, go at least half year, not more than 1.5 years
;
         FOR i = istart, ny-1 DO BEGIN


            NextIdx=where(Cross.X GT CurX+bpy*WinMin and $
                          Cross.X LT CurX+bpy*WinMax, nNext)

            IF (nNext gt 0) THEN BEGIN

;
; Min ND Method
;
               NextSOSIdx=where(Cross.y[NextIdx] eq $
                            min(Cross.y[NextIdx]))

               SOST[i]=Cross.x[NextIdx[NextSOSIdx[0]]]
               SOSN[i]=Cross.Y[NextIdx[NextSOSIdx[0]]]
               CurX=SOST[i]

            END ELSE CurX=CurX+bpy

         END;FOR 

         ;SOST=rmzeros(sost, /trail)
         ;SOSN=rmzeros(sosn, /trail)

         SOS={SOST:SOST, SOSN:SOSN}

      END;nSize[0]=1

      3: BEGIN
         FirstSOST=fltarr(nSize[1],nSize[2])
         FirstSOSN=fltarr(nSize[1],nSize[2])
         CurX=fltarr(nSize[1],nSize[2])
         SOST=fltarr(nSize[1],nSize[2],ny)+FILL
         SOSN=fltarr(nSize[1],nSize[2],ny)+FILL

         FOR i = 0, nSize[1]-1 DO BEGIN
            FOR j = 0, nSize[2]-1 DO BEGIN

               FirstIdx=where(Cross.X[i,j,*] LT WinFirst*bpy AND $
                              Cross.X[i,j,*] GE 0, nFirstSOS)

; Earliest Method
;               FirstSOSIdx=where(NDVI[fix(Cross.x[i,j,firstidx])] eq $
;                             min(NDVI[fix(Cross.x[i,j,firstidx])]), nmin)

if firstidx[0] EQ -1 then firstidx=0

; Min ND method
               IF (nFirstSOS GT 0) THEN BEGIN
                  FirstSOSIdx=where(Cross.y[i,j,firstidx] eq $
                             min(Cross.y[i,j,firstidx]), nmin)


                  FirstSOST[i,j]=Cross.x[i,j,FirstIdx[FirstSOSIdx[0]]]
                  FirstSOSN[i,j]=Cross.Y[i,j,FirstIdx[FirstSOSIdx[0]]]
               END ELSE BEGIN
                  FirstSOST[i,j]=0
                  FirstSOSN[i,j]=0
               END

               CurX[i,j]=FirstSOST[i,j]

               SOST[i,j,0]=FirstSOST[i,j]
               SOSN[i,j,0]=FirstSOSN[i,j]

               FOR k = 1, ny-1 DO BEGIN

                  NextIdx=where(Cross.X[i,j,*] GT CurX[i,j]+bpy*WinMin AND $
                                Cross.X[i,j,*] LT CurX[i,j]+bpy*WinMax, nNext)

                  IF (nNext gt 0) THEN BEGIN

                     NextSOSIdx=where(Cross.y[i,j,NextIdx] eq $
                                  min(Cross.y[i,j,NextIdx]), nmin)

                     SOST[i,j,k]=Cross.x[i,j,NextIdx[NextSOSIdx[0]]]
                     SOSN[i,j,k]=Cross.Y[i,j,NextIdx[NextSOSIdx[0]]]
                     CurX[i,j]=SOST[i,j,k]


                  END ELSE CurX[i,j]=CurX[i,j]+bpy

               END; FOR k
            END; FOR j 
         END; FOR i 
         
         SOS={SOST:SOST, SOSN:SOSN}

      END;nSize[0]=3


      ELSE:
   ENDCASE




RETURN, SOS
END
