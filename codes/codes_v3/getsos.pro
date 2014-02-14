FUNCTION  GetSOS, Cross, NDVI, bq, x, bpy, FMA
;
; These numbers are the window (*bpy) from the
; current SOS in which to look for the next SOS
; jzhu, 9/12/2011, found SOS and EOS is very snesitive to the windows range of moving average.
; getSOS2.pro choose the the sos from the candidate point with minimun ndvi, try to use maximun slope difference to determine the sos
; jzhu, 9/23/2011, cross includes crossover, 20% points, and maxslope point, pick reasenable point as SOS among cross
; 
;if sos_possib1 > 20% point, sos_possib2 = sos_possi1, otherwise sos_possb2 = 20%point,find a nearest point from eos_possb2 to 1, which is not snow point, 
;this point is SOS
    
FILL=-1.
WinFirst=0.5 ;the maximum start season must less than WinFirst*bpy
WinMin=0.5
WinMax=1.5

;---get idx of maximun ndvi point
num=n_elements(NDVI)
mxidx=where(NDVI EQ max(NDVI))
mxidxst=mxidx(0)
mxidxed=mxidx(n_elements(mxidx)-1) 
lastidx=n_elements(NDVI)-1 ; lastidx
;
; Calculation the slope of ndvi and fma for slope method
;
      nFMA=n_elements(FMA)
;      FSlope=fltarr(nFMA-1)
;      For i = 0, nFMA-2 DO $
;         FSlope[i]=FMA[i+1]-FMA[i]

      nNDVI=n_elements(NDVI)
;      NSlope=fltarr(nNDVI-1)
;      For i = 0, nNDVI-2 DO $
;         NSlope[i]=NDVI[i+1]-NDVI[i]


;      ny=N_Elements(NDVI)/bpy

      SOST=fltarr(1)
      SOSN=fltarr(1)
      SOST[0]=FILL
      SOSN[0]=FILL

; First SOS must be within 0 to WinFirst*bpy
;
     
;----find the first 20% point as x20
idx20=where(cross.t EQ 1,cnt1)

if cnt1 LE 0 then begin  ; <2> if no 20% point, set sosx as possiblx

x20=0
y20=NDVI(x20)

;sosx=0
;sosy=0
;goto,lb11

endif else begin  ; <2> compare possibx with 20% point,<2>

;--when there are more than one 20% points, choose one which is the most close to the maximun slop point
;slopex=( cross.x(where(cross.t EQ 2) ) )(0)
;gapmin = min(  abs(cross.x(idx20)-slopex)  )
;x20=cross.x(  (where( abs(cross.x - slopex) EQ  gapmin ) )(0)  )
;y20=cross.y(  (where( abs(cross.x - slopex) EQ  gapmin ) )(0)  )

;---when there are more than one 20% points, choose one which is the closest to possibx
;if possibx GT 0 then begin
;gapmin=min(abs(cross.x(idx20)-possibx))
;x20=cross.x( (where(abs(cross.x-possibx) EQ gapmin))(0) )
;y20=cross.y( (where(abs(cross.x-possibx) EQ gapmin))(0) )
;endif else begin
;slopex=( cross.x(where(cross.t EQ 2) ) )(0)
;gapmin = min(  abs(cross.x(idx20)-slopex)  )
;x20=cross.x(  (where( abs(cross.x - slopex) EQ  gapmin ) )(0)  )
;y20=cross.y(  (where( abs(cross.x - slopex) EQ  gapmin ) )(0)  )
;endelse

;--when more than one 20% points, choose the first one
x20=cross.x( idx20(0) )
y20=cross.y( idx20(0) )

endelse ;<2>

;---------  find possibx in cross_only, 

     t0idx = where(cross.t EQ 0,t0cnt) ; t0--crossover type
  
     if t0cnt LT 1 then begin ; <0> no  crossover points, possiblex=0
     possibx=0
     possiby=0
     
     endif else begin ; <0> looking for possiblex
     
       cross_only={X:cross.x(t0idx), Y:cross.y(t0idx), S:cross.s(t0idx),T:cross.t(t0idx),C:cross.c(t0idx), N:t0cnt}
       
       ;  FirstIdx=where(Cross_only.X LT WinFirst*bpy and Cross_only.X LT min([mxidxst,0.5*bpy]), nFirstSOS)
          FirstIdx=where(Cross_only.X LT mxidxst, nFirstSOS)
          
          ;I think possibx never houldn't be great than 28 for total 42 band
          
         if firstidx[0] EQ -1 then begin
         firstidx=0
         nFirstSOS=0
        endif
            
         
    if(nFirstSOS gt 0) THEN  BEGIN   ; <1> have possiblex <1>    



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

; e. get slopes of each firstidx by using next 4 points linfit       
    ;         numtype0=n_elements(firstidx)
    ;         slopes=fltarr(numtype0)
    ;         for kk=0,numtype0-1 do begin
    ;          xx=fix([cross_only.x[firstidx(kk)]+3, cross_only.x[firstidx(kk)]+2, cross_only.x[firstidx(kk)]+1,cross_only.x[firstidx(kk)] ])
    ;          yy=ndvi(xx)
    ;          tmp= linfit(xx,yy)
    ;          slopes(kk)=tmp(1)
    ;         endfor 
    ;         firstsosidx = where(slopes EQ max(slopes) )
; f. use slope in cross_only to pick the greatest slope
;           FirstSOSIdx= where(cross_only.s(firstidx) EQ max( cross_only.s(firstidx) ) )              
               
; g. use the crossover point which is the most close to the 20% point as possibx

           FirstSOSIdx =where( abs(cross_only.x(firstidx)-x20) EQ min( abs(cross_only.x(firstidx)-x20 ) ) )
             
                
;---- check FirstSOSidx(0), if it is snow(4b), compare it with 20% point,

         possibx = cross_only.X[ FirstSOSIdx[n_elements(FirstSOSidx)-1 ] ]
         possiby = cross_only.Y[ FirstSOSIdx[n_elements(FirstSOSidx)-1 ] ]

   endif else begin ;<1> not found possiblex
     possibx=0

     possiby=0

   endelse  ; <1>                

endelse  ;<0>
          



;---- compare x20 and possiblex

      if possibx GT 0 then begin 
      
        if possibx LT x20 then begin  ;  make sure possiblx equal or greater than x20
        
        possibx=x20

        possiby=y20
        
        endif 
        ;else begin
        ;        print, 'possibx Greater than x20'
        
        ;endelse
         
     endif else begin

       possibx=x20

       possiby=y20

     endelse
        
        
        if possibx LT 0 or possibx GE mxidxst then begin  ;<5>
        
        sosx=0

        sosy=0

        endif else begin ;<5>
          
        sosx=possibx
        sosy=possiby
       
       endelse ;<5>   
        
        ;else begin  ;<5>
        
        ;if bq(fix(possibx)) EQ 0b and bq(fix(possibx)+1) EQ 0b and fix(possibx)+1 LE lastidx  then begin ;<4>      

        ;sosx=possibx

        ;sosy=possiby

        ; endif else begin ;<4> possibx is snow, found true sosx between possibx+1 to mxidxst <4>
         
        ; x20g = where( bq( fix(possibx)+1 : n_elements(bq)-1  ) EQ 0b, possibcnt )
         
        ; if possibcnt GT 0 then begin 
         
        ; sosx= fix(possibx)+1+x20g(0)
        ; sosy=ndvi(sosx)
         
        ; endif else begin 
         
        ; sosx=0
        ; sosy=0
         
        ; endelse
          
         
        ; endelse  ; endof <4>   
        ; endelse  ; <5>
         
lb11:     
          SOST[0]=sosx
          SOSN[0]=sosy
          
       SOS={SOST:SOST,SOSN:SOSN}   

RETURN, SOS
END
