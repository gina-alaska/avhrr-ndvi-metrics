;jzhu, 8/1/2011. THis program modified from GetEOS2.pro. GetEOS2.pro picks the END of Season by thinking EOS occurs at where the NDVI is minimum. 
;This program choose the point where slope of NDVI is smallest.
;if eos_possib1 < 20% point, eos_possib2 = eos_possi1, otherwise eos_possb2 = 20%point,find a nearest point from eos_possb2 to 1, which is not snow point, 
;this point is EOS
;jzhu, 12/12/2011, modify from geteos_ver15.pro, uses different stragegy to pick up the final EOS among the crossover. First, find the last 20% point; then
;find the possibx point which is defined as the crossover point which is the most closest to the 20% point; pick the smaller point between the possibx and 
;the last 20% point as the possibx1, find the "good" last point between 0 to possibx1 as EOS. 
; 
;jzhu, 6/27/2013, modify from geteos.pro, when there are no 20% line, and last point greather than 20% value, uses the last point as EOS  

FUNCTION  GetEOS_v2, Cross, NDVI, bq, x,bpy,SOS,bma

FILL=-1.

adj_range=3 ; adjustment range , if range between 20% crossover and crossover greather than adjustment rannge, adjust, otherwise, use 20% crossover as EOS 
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
      nbMA=n_elements(bMA)
 ;     bSlope=fltarr(nbMA-1)
;     For i = 0, nbMA-2 DO $
;         bSlope[i]=bMA[i+1]-bMA[i]

      nNDVI=n_elements(NDVI)
;      NSlope=fltarr(nNDVI-1)
;      For i = 0, nNDVI-2 DO $
;         NSlope[i]=NDVI[i+1]-NDVI[i]



      EOST=fltarr(1)
      EOSN=fltarr(1)
      EOST[0]=FILL
      EOSN[0]=FILL



 
;---- find the last 20% point

idx20=where(cross.t EQ 1, cnt1)

if cnt1 LE 0 then begin  ; <3> if no 20% point, set the eosx and eosy as the last point index and value,respectively

x20=num-1

y20=NDVI(num-1)

endif else begin  ; <3>

;---choose the last 20% point
  
  flg_lcross=1
  
  x20=cross.x( idx20( n_elements(idx20)-1) )

  y20=cross.y( idx20( n_elements(idx20)-1) )

;---make sure x20 must be greather than SOS.sost and greater than mxidxed, otherwise, x20=num-1

  if x20 LE SOS.sost or x20 LE mxidxed then begin
     
     flg_lcross=0
     
     x20=num-1
     
     y20=ndvi(num-1)
     
  endif

endelse ;<3>

;----find the possibx among the crossover points

;-----only consider crossover points for determine if the crossover is valid
 
t0idx = where(cross.t EQ 0,t0cnt) ; t0--crossover type, 0--crossover, 1--20% point, 2--extremeslope point
  
if t0cnt LT 1 then begin ; <0> no crossover
     
     possibx=0

     possiby=0
     
endif else begin   ;<0>
      
        cross_only={X:cross.x(t0idx), Y:cross.y(t0idx), S:cross.s(t0idx),T:cross.t(t0idx),C:cross.c(t0idx), N:t0cnt}
        NextIdx=where(Cross_only.X GT SOS.sost AND $
                      Cross_only.X GT mxidxed  AND $
                      Cross_only.X LT nNDVI-1,nNext)

;           if NextIdx[0] EQ -1 then begin
;             Nextidx=0
;             nNExt=0
;           endif
            

    IF (nNext gt 0) THEN BEGIN  ;<1> have possiblex,<1>

;pick the one which has the minimun slope -------------

;               slope=fltarr(nNEXT)
;               slope[NextIdx]= NDVI[fix(Cross_only.x[NextIdx])]-NDVI[fix(Cross_only.x[NextIdx])-1]
;               NextEOSIdx=where(slope EQ min(slope[NextIdx]) )

;pick the one which has the minimum slope difference method
         
;      NextEOSIdx=where(NSlope[fix(Cross_only.x[Nextidx])]-bSlope[fix(Cross_only.x[Nextidx])] eq $
;                    min(NSlope[fix(Cross_only.x[Nextidx])]-bSlope[fix(Cross_only.x[Nextidx])]))

;get slopes of each NEXTidx by using prevoius 4 points linfit, then pick the minimum slope point      
 
;             numtype0=n_elements(Nextidx)
;             slopes=fltarr(numtype0)
;             for kk=0,numtype0-1 do begin
;               xx=fix([cross_only.x[Nextidx(kk)]-3, cross_only.x[Nextidx(kk)]-2, cross_only.x[Nextidx(kk)]-1,cross_only.x[Nextidx(kk)] ])
;               yy=ndvi(xx)
;               tmp= linfit(xx,yy)
;               slopes(kk)=tmp(1)
;             endfor 
;             NextEOSidx = where(slopes EQ min(slopes) )    
             
;pick the crossover point which is the most close to the x20

         NextEOSIdx=where( abs(cross_only.x(NextIdx)-x20)  EQ min( abs(cross_only.x(NextIdx)-x20) ) )

;-----------------------------------------------------------

         flg_mcross=1

         possibx = cross_only.X[ NextEOSIdx[0] ]
         possiby = cross_only.Y[ NextEOSIdx[0] ]
         
    endif else begin ;<1>

       possibx=0
       possiby=0

endelse  ;<1>

endelse ;<0>

;------------------------------------------------

;compare x20 and possibx, if x20 is maller than last point of ndvi and possibx is greater than 0
;then pick the smaller one between x20 and possiblx, otherwise, uses x20 as EOS
;consider crossover when it is within adj_range points range (3*7=21 days) from x20, otherwise, choose x20 as EOS
;       
      ;  if abs(possibx-x20) LE 5 and x20 LT num-1 then begin
      
if flg_lcross EQ 0 then begin ; no 20% crossover points
  
   if flg_mcross EQ 0 then begin   ; no 20% crossover, no crossover points
    
      eosx=x20

      eosy=y20

   endif else begin   ; no 20% crossover, has crossover
    
     if x20-possibx GT adj_range then begin ; 
      
       eosx=x20

       eosy=y20

     endif else begin
      
       eosx=possibx

       eosy=possiby

     endelse   

   endelse
   
endif else begin  ; has 20% crossover
  
  if flg_mcross EQ 0 then begin ; has 20% crossover but not crossover
    
    eosx=x20
    
    eosy=y20
 
  endif else begin   ; has 20% crossover and crossover points
    
    if abs(possibx-x20) LE adj_range then begin  
        
         if possibx GT x20 then begin  ; make sure eos is equal or less than 20% point
        
            eosx=x20
       
            eosy=y20
       
         endif else begin
            
            eosx=possibx
            
            eosy=possiby
 
         endelse    
         
    endif else begin 
       
         eosx=x20
       
         eosy=y20
       
    endelse

  endelse

endelse
        
        
if eosx LE SOS.sost or eosx GT nNDVI-1 or ( SOS.sost EQ 0 and SOS.sosn EQ 0 ) then begin ; <5>
        
       eosx=0
           
       eosy=0
        
endif ;<5>
         
lb11:
      
               EOST[0]=eosx
               EOSN[0]=eosy
               EOS={EOST:EOST, EOSN:EOSN}

RETURN, EOS

END
