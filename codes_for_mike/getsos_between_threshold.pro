FUNCTION  GetSOS_between_threshold, Cross, NDVI, bq, x, bpy, FMA
;
; These numbers are the window (*bpy) from the
; current SOS in which to look for the next SOS
; jzhu, 9/12/2011, found SOS and EOS is very snesitive to the windows range of moving average.
; getSOS2.pro choose the the sos from the candidate point with minimun ndvi, try to use maximun slope difference to determine the sos
; jzhu, 9/23/2011, cross includes crossover, 20% points, and maxslope point, pick reasenable point as SOS among cross
    
FILL=-1.
WinFirst=1.0
WinMin=0.5
WinMax=1.5

;---get idx of maximun ndvi point
mxidx=where(NDVI EQ max(NDVI))
mxidxst=mxidx(0)
mxidxed=mxidx(n_elements(mxidx)-1) 

;
; Calculation the slope of ndvi and fma for slope method
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
; NOTE: I still need to do something in case it doesn't find a first sos
;

      nSize=Size(NDVI)
      ny=nSize[nSize[0]]/bpy + (nSize[nSize[0]] mod bpy gt 0)

   CASE (nSize[0]) OF

      1: BEGIN
         SOST=fltarr(ny)+FILL
         SOSN=fltarr(ny)+FILL
;
; First SOS must be within first WinFirst*bpy and must less then min(mxidxst,0.5*bpy)
;
     
     t0idx = where(cross.t EQ 0,t0cnt) ; t0--crossover type
  
     if t0cnt GT 0 then begin
     
       cross_only={X:cross.x(t0idx), Y:cross.y(t0idx), S:cross.s(t0idx),T:cross.t(t0idx),C:cross.c(t0idx), N:t0cnt}
       
         FirstIdx=where(Cross_only.X LT WinFirst*bpy and Cross_only.X LT min([mxidxst,0.5*bpy]), nFirstSOS)

         if firstidx[0] EQ -1 then firstidx=0
         
     endif else begin
     
        firstidx=0
        nFirstSOS=0
     endelse
            
         
if(nFirstSOS gt 0) THEN  BEGIN



; 4 possible methods, test which methos is the best 

;
; a. Min ND Method
;
;      FirstSOSIdx=where(Cross.y[firstidx] eq $
;                          min(Cross.y[firstidx]))

;
; b. maximun Slope Method, orginal was miminun, jzhu thinks it should be maximun
;
;      FirstSOSIdx=where(NDVI[fix(Cross.x[firstidx])] eq $
;                    max(NDVI[fix(Cross.x[firstidx])]))

;
; c. maximun slope difference (slope of NDVI - slope of FMA ) Method
;
;
;      FirstSOSIdx=where(NSlope[fix(Cross_only.x[firstidx])]-FSlope[fix(Cross_only.x[firstidx])] eq $
;                    max(NSlope[fix(Cross_only.x[firstidx])]-FSlope[fix(Cross_only.x[firstidx])]))

;
; d. Maximun ND Change Method
;
;      FirstSOSIdx=where(NDVI[fix(Cross.x[firstidx]+2)]-NDVI[fix(Cross.x[firstidx])] eq $
;                    max(NDVI[fix(Cross.x[firstidx]+2)]-NDVI[fix(Cross.x[firstidx])]))

     ;--- get slopes of each firstidx by using next 4 points linfit       
             numtype0=n_elements(firstidx)
             slopes=fltarr(numtype0)
             
             for kk=0,numtype0-1 do begin
              xx=fix([cross_only.x[firstidx(kk)]+3, cross_only.x[firstidx(kk)]+2, cross_only.x[firstidx(kk)]+1,cross_only.x[firstidx(kk)] ])
              yy=ndvi(xx)
              tmp= linfit(xx,yy)
              slopes(kk)=tmp(1)
             endfor 
             
           firstsosidx = where(slopes EQ max(slopes) )    
             
                
;---- check FirstSOSidx(0), if it is snow(4b), compare it with 20% point,

         possibx = cross_only.X[ FirstSOSIdx[n_elements(FirstSOSidx)-1 ] ]
         possiby = cross_only.Y[ FirstSOSIdx[n_elements(FirstSOSidx)-1 ] ]
         
         
 ;---- if there are more than one 20% points, choose one which is the most close to the maximun slop point

idx20=where(cross.t EQ 1,cnt1)

if cnt1 LE 0 then begin

sosx=possibx

sosy=possiby

endif else begin  ; compare possibx to 20% point


;--- compare possib point with 20% point
 
slopex=( cross.x(where(cross.t EQ 2) ) )(0)

gapmin = min( cross.x(idx20)-slopex )


x20=cross.x(  (where( cross.x - slopex EQ  gapmin ) )(0)  )

y20=cross.y(  (where( cross.x - slopex EQ  gapmin ) )(0)  )
             
      ;---- between 20% and possiblex
      ;
      ;---- check [possibx:x20]
        
      if possibx LE x20 then begin  ;  [possibx: x20]
        
        tmp = bq[fix(possibx):fix(x20)]
        
        possibidx=where(tmp NE 4b,possibcnt)
        
        if possibcnt GT 0 then begin  ; found non-snow points in [possibx:x20]
        
          if x(possibidx(0)+fix(possibx))  EQ fix(possibx) then begin
       
            sosx = possibx
            sosy = possiby
            
          endif else begin
      
             sosx =possibidx(0)+fix(possibx)
             sosy=ndvi(sosx)
                          
          endelse
       
       endif else begin  ; not find non-snow points in [possibx:x20]
         
         ;check [fix(x20)+1 : mxidxst]
         
         x20g = where( bq( fix(x20)+1 : n_elements(bq)-1  ) NE 4b, possibcnt )
         
         if possibcnt GT 0 then begin 
         
         sosx= fix(x20)+1+x20g(0)
         sosy=ndvi(sosx)
         
         ;sosy= yvalline(x,ndvi,sosx)
         
         endif else begin 
         
         sosx=0
         sosy=0
         
         endelse
          
         
       endelse      
      
      endif else begin            ; [x20:possiblex] 
       
       ;----check [fix(x20):fix(possibx)+1]
        
        if  possibx mod fix(possibx) then begin
           endx = fix(possibx)+1
        endif else begin
           endx = possibx
        endelse
            tmp= bq[x20: endx]
            
        possibidx=where(tmp NE 4b,possibcnt)
        
        if possibcnt GT 0 then begin  ; found non-snow points in [x20:possiblx]
          
           num=n_elements(possibidx)
           
          if x( possibidx(num-1) + fix(x20) ) EQ endx then begin
            sosx = possibx
            sosy = possiby
            
          endif else begin
            sosx = possibidx(num-1) + fix(x20)
            sosy=ndvi(sosx)
            
            ;sosy = yvalline(x,ndvi,sosx)
            
          endelse
       
       endif else begin  ; not find non-snow points in [x20: possibx]
        ; get the first non-snow point between possibx to mxidxst as sos point
         
         x20g = where( bq( fix(possibx)+1 : n_elements(bq)-1 ) NE 4b, possibcnt )
         
         if possibcnt GT 0 then begin
         
         sosx=x20g(0) + fix(possibx)+1
         sosy=ndvi(sosx)
         
         ;sosy=yvalline(x,ndvi,sosx)
         
         endif else begin
         
         sosx=0
         
         sosy=0
         
         endelse
         
         
         
       endelse      
                 
     endelse ;  
            
 
 
 
     endelse   ; end of compare possibx to 20% point
     
          FirstSOST=sosx
          
          FirstSOSN=sosy


 

 



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

      END;nSize[0]=1, case 1

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
