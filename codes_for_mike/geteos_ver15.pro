;jzhu, 8/1/2011. THis program modified from GetEOS2.pro. GetEOS2.pro picks the END of Season by thinking EOS occurs at where the NDVI is minimum. 
;This program choose the point where slope of NDVI is smallest.
;if eos_possib1 < 20% point, eos_possib2 = eos_possi1, otherwise eos_possb2 = 20%point,find a nearest point from eos_possb2 to 1, which is not snow point, 
;this point is EOS


FUNCTION  GetEOS_ver15, Cross, NDVI, bq, x,bpy,SOS,bma

FILL=-1.

;---get idx of maximun ndvi point
mxidx=where(NDVI EQ max(NDVI))
mxidxst=mxidx(0)
mxidxed=mxidx(n_elements(mxidx)-1)
lastidx=n_elements(NDVI)-1 ; lastidx 
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
   WinMin=0.1    ;0.25   ; for alaska region, 30 days, winMin=0.1, about5 weeks
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
 
 ;-----only consider crossover points for determine if the crossover is valid
 
 
     t0idx = where(cross.t EQ 0,t0cnt) ; t0--crossover type,0--crossover, 1--20% point, 2--extremeslope point
  
     if t0cnt LT 1 then begin ; <0> no crossover
     
     possibx=0
     possiby=0
     endif else begin   ;<0>
      
      
      cross_only={X:cross.x(t0idx), Y:cross.y(t0idx), S:cross.s(t0idx),T:cross.t(t0idx),C:cross.c(t0idx), N:t0cnt}
      
            NextIdx=where(Cross_only.X GT CurX+WinMin*bpy AND $
                          Cross_only.X LT CurX+WinMax*bpy AND $
                          Cross_only.X LT nNDVI-2, nNext)
;                          
;            NextIdx=where(Cross.X GT CurX AND $
;                          Cross.X LT CurX+WinMax*bpy AND $
;                          Cross.X LT nNDVI-2, nNext)
     if NextIdx[0] EQ -1 then begin
     
        Nextidx=0
        nNExt=0
        
     endif
            

IF (nNext gt 0) THEN BEGIN  ;<1> have possiblex,<1>

 
   
    
;               possi_NextEOSIdx=where(NDVI[fix(Cross.x[NextIdx])] eq $
;                            min(NDVI[fix(Cross.x[NextIdx])]))

;
; minimun ndvi method, this method is used in geteod2.pro

;               psble1_NextEOSIdx=where(Cross.y[NextIdx] eq $
;                            min(Cross.y[NextIdx]))


 
;GetEOS3.pro method, slope method, jzhu, 8/10/2011-------------------
               
;minimun slope method -------------

               slope=fltarr(nNEXT)
               slope[NextIdx]= NDVI[fix(Cross_only.x[NextIdx])]-NDVI[fix(Cross_only.x[NextIdx])-1]
               NextEOSIdx=where(slope EQ min(slope[NextIdx]) )

;slope difference method
         
;      NextEOSIdx=where(NSlope[fix(Cross_only.x[Nextidx])]-bSlope[fix(Cross_only.x[Nextidx])] eq $
;                    min(NSlope[fix(Cross_only.x[Nextidx])]-bSlope[fix(Cross_only.x[Nextidx])]))

;
; Max ND Change Method, if you want this method, you need modify the following segement program
;
;      FirstSOSIdx=where(NDVI[fix(Cross.x[firstidx]+1)]-NDVI[fix(Cross.x[firstidx])] eq $
;                    max(NDVI[fix(Cross.x[firstidx]+1)]-NDVI[fix(Cross.x[firstidx])]))


;--- get slopes of each NEXTidx by using prevoius 4 points linfit      
 
;             numtype0=n_elements(Nextidx)
;             slopes=fltarr(numtype0)
             
;             for kk=0,numtype0-1 do begin
;              xx=fix([cross_only.x[Nextidx(kk)]-3, cross_only.x[Nextidx(kk)]-2, cross_only.x[Nextidx(kk)]-1,cross_only.x[Nextidx(kk)] ])
;              yy=ndvi(xx)
;              tmp= linfit(xx,yy)
;              slopes(kk)=tmp(1)
;             endfor 
;             NextEOSidx = where(slopes EQ min(slopes) )    
             



;---- check FirstSOSidx(0), if it is snow(4b), compare it with 20% point,




         possibx = cross_only.X[ NextEOSIdx[0] ]
         possiby = cross_only.Y[ NextEOSIdx[0] ]
         
endif else begin ;<1>

possibx=0
possiby=0

endelse  ;<1>

endelse ;<0>
  
;---- possibx=0 do not find sos
if possibx EQ 0 then begin
eosx=0
eosy=0
goto,lb11
endif
  
         
 ;---- if there are more than one 20% points, choose one which is the most close to the maximun slop point

idx20=where(cross.t EQ 1, cnt1)

if cnt1 LE 0 then begin  ; <3>

eosx = possibx
eosy = possiby

endif else begin  ; compare possibx to 20% pointm, <3>
 
;---when more than one 20% points, choose one with the minimum slope
;slopex= (cross.x(where(cross.t EQ 2)))(0)
;gapmin = min( abs(cross.x(idx20)-slopex) )
;x20=cross.x( ( where( abs(cross.x - slopex) EQ  gapmin ) )(0) )
;y20=cross.y( ( where( abs(cross.x - slopex) EQ  gapmin ) )(0) )

;---when more than one 20% points, choose one that is the closest to possibx
if possibx GT 0 then begin
gapmin=min (abs(cross.x(idx20)-possibx) )
x20=cross.x(  (where( abs(cross.x - possibx) EQ  gapmin ) )(0)  )
y20=cross.y(  (where( abs(cross.x - possibx) EQ  gapmin ) )(0)  )
endif else begin
slopex= (cross.x(where(cross.t EQ 2)))(0)
gapmin = min( abs(cross.x(idx20)-slopex) )
x20=cross.x( ( where( abs(cross.x - slopex) EQ  gapmin ) )(0) )
y20=cross.y( ( where( abs(cross.x - slopex) EQ  gapmin ) )(0) )
endelse

;--when more than one 20%, choose the last one
;x20=cross.x( idx20(n_elements(idx20)-1) )
;y20=cross.y( idx20(n_elements(idx20)-1) )

        
        if possibx GT 0 then begin
         
         if possibx GT x20 then begin  ;  make sure eos is equal or less than 20% point
        
         possibx=x20
         possiby=y20
         
         endif else begin
         print, 'possiblx is less than x20
         endelse 
         
         endif else begin 
         possibx=x20
         possiby=y20
         endelse
        
        
        
        if possibx LE 0 or possibx GE lastidx-1 then begin ; <5>
        
         if possibx LE 0 then begin
         eosx=0
         eosy=0
         endif else begin
         eosx=possibx
         eosy=possiby
         endelse
         
        endif else begin ;<5> 
        
         ;check [mxidxed:possibx]
         
        ; if bq( fix(possibx) ) NE 4b and bq (fix(possibx)+1 ) NE 4b then begin  ; found sosx=possibx, <4>
        ;guarantee the eos must be good point, more strict than guarantee eos is not snow point 
         
         v=possibx mod fix(possibx)
         if ( v EQ 0 and bq( fix(possibx) ) EQ 0b and bq(fix(possibx)-1) EQ 0b and fix(possibx)-1 GE 0) $
         or ( v NE 0 and bq( fix(possibx) ) EQ 0b and bq(fix(possibx)+1) EQ 0b and fix(possibx)+1 LE lastidx) then begin ;found EOS <4> 
         
         eosx=possibx
         eosy=possiby
         
         endif else begin ; find eos between mxidxed to possibx, <4>
         
         x20g = where( bq( 0:fix(possibx) ) EQ 0b, possibcnt )
         
         if possibcnt GT 0 then begin
         
         eosx = x20g( n_elements(x20g)-1 )
          
         eosy=ndvi(eosx)
         
         endif else begin
         
         eosx=0
         eosy=0
         
         endelse
         
         endelse  ;endof <4>     
         
         endelse  ; <5>
         
         endelse   ; <3> end of compare possibx to 20% point, <3>
              
lb11:
      
               EOST[i]=eosx
               EOSN[i]=eosy
      

END;FOR 
      
;         IF (EOST[nSOS-1] EQ 0) then  EOST[nSOS-1]=nNDVI-1
;         IF (EOSN[nSOS-1] EQ 0) then  EOSN[nSOS-1]=NDVI[nNDVI-1]
      
;         EOST=rmzeros(eost, /trail)
;         EOSN=rmzeros(eosn, /trail)
      
         EOS={EOST:EOST, EOSN:EOSN}

END; nSize[0]=1, case 1


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
