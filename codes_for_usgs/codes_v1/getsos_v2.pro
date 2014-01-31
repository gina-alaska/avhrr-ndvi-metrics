FUNCTION  GetSOS_v2, Cross, NDVI, bq, x, bpy, FMA
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
WinFirst=0.75 ;the maximum start season must less than WinFirst*bpy
WinMin=0.5
WinMax=1.5
adj_range=3 ; adjustment range, if the range between crossover and 20% crossove is greather than the adj_range, do not adjust, use 20% crossover as SOS day
flg_lcross=0 ; 0--no 20% crossover point,1--has crossover point
flg_mcross=0 ; 0-- no crossover point, 1- has crossover point

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

      nNDVI=n_elements(NDVI)


      SOST=fltarr(1)
      SOSN=fltarr(1)
      SOST[0]=FILL
      SOSN[0]=FILL

; First SOS must be within 0 to WinFirst*bpy
;
     
;----find the first 20%point as x20
idx20=where(cross.t EQ 1,cnt1)

if cnt1 LE 0 then begin  ; <2> if no 20% point, set x20 and y20 as the first index of ndvi and its value, respectively

x20=0
y20=NDVI(x20)

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

flg_lcross=1 ; has line crossover point

x20=cross.x( idx20(0) )

y20=cross.y( idx20(0) )

endelse ;<2>

;---------  find possibx in cross_only, 

t0idx = where(cross.t EQ 0,t0cnt) ; t0--crossover type
  
if t0cnt LT 1 then begin ; <0> no crossover points, possiblex=0
      
   possibx=0
  
   possiby=0
     
endif else begin ; <0> looking for possiblex
     
   cross_only={X:cross.x(t0idx), Y:cross.y(t0idx), S:cross.s(t0idx),T:cross.t(t0idx),C:cross.c(t0idx), N:t0cnt}
       
   FirstIdx=where(Cross_only.X LT mxidxst, nFirstSOS)
          
            
   if(nFirstSOS gt 0) THEN  BEGIN   ; <1> have possiblx <1>    



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
          
      flg_mcross=1 ;  has crossover point
          
      FirstSOSIdx =where( abs(cross_only.x(firstidx)-x20) EQ min( abs(cross_only.x(firstidx)-x20 ) ) )
             
                
;---- check FirstSOSidx(0), if it is snow(4b), compare it with 20% point,

      possibx = cross_only.X[ FirstSOSIdx[n_elements(FirstSOSidx)-1 ] ]
   
      possiby = cross_only.Y[ FirstSOSIdx[n_elements(FirstSOSidx)-1 ] ]

    endif else begin ;<1> not found possiblx
 
      possibx=0
   
      possiby=0
 
   endelse  ; <1>                

endelse  ;<0>
          



;---- compare x20 and possiblex, consider crossocver only when the range between crossover and x20 is within 5*7=35 days

      ;if abs(possibx-x20) LE 5 and x20 GT 0 then begin ; possible and x20 are greater than 0

if flg_lcross EQ 0 then begin    ; #1,no 20% line crosss points
      
        if  flg_mcross EQ 0 then begin ; #2, no 20% crossover and no crossoer points
          
           sosx = x20
          
           sosy = y20    
        
        endif else begin ; #2, no 20% crossover and has crossover
              
          if possibx-x20 GT adj_range then begin ; #3
          
            sosx = x20
           
            sosy = y20
           
          endif else begin  ;#3
          
            sosx = possibx
            
            sosy = possiby
         
          endelse   ; #3
               
       endelse ;#2
       
endif else begin   ; #1, has 20% line crossover points
      
        if flg_mcross EQ 0 then begin ; #4, has 20% crossover and no crossoer points     
                  
           sosx = x20
           
           sosy = y20
 
        endif else begin ; #4, has 20% crossover and has corssover points
            
          if abs(possibx-x20) LE adj_range then begin  ;#5
      
             if possibx LT x20 then begin  ; #6, make sure possiblx equal or greater than x20
        
                sosx=x20
           
                sosy=y20
        
             endif else begin  ;#6
              
                sosx =possibx
                
                sosy =possiby
                
             endelse  ;#6
                
         
          endif else begin  ;#5
      
              sosx=x20
      
              sosy=y20

          endelse  ;#5
      
       endelse ;#4
        
endelse ;#1
        

if sosx LT 0 or sosx GE mxidxst then begin  ;<5>
        
          sosx=0
 
          sosy=0
endif ;<5>
        
lb11:     
          SOST[0]=sosx
          SOSN[0]=sosy
          SOS={SOST:SOST,SOSN:SOSN}   

RETURN, SOS
END
