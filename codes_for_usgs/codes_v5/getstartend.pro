FUNCTION  GetStartEnd, NDVI, wl, ny, dt

;
; Define structure
;
   start_end = {SOST:fltarr(ny*2), $
             SOSN:fltarr(ny*2), $
             EOST:fltarr(ny*2), $
             EOSN:fltarr(ny*2), $
             FwdMA:fltarr(n_elements(ndvi)), $
             BkwdMA:fltarr(n_elements(ndvi)) $
            }

   nNDVI = N_Elements(NDVI)


;
; Calculate forward and backward moving averages
;
   Start_End.FwdMA=forward_ma(ndvi,wl)
   Start_End.BkwdMA=backward_ma(ndvi,wl)

   x=findgen(nNDVI)
   fndvi=float(ndvi)

   ffma=float(Start_End.FwdMA)
   fbma=float(Start_End.BkwdMA)


   fxpts=fltarr(nNDVI-1)
   fypts=fltarr(nNDVI-1)
   fcpts=fltarr(nNDVI-1)

   bxpts=fltarr(nNDVI-1)
   bypts=fltarr(nNDVI-1)
   bcpts=fltarr(nNDVI-1)

   soscnt=0
   eoscnt=0

   for i = 0, nNDVI-2 do begin

;
; Forward for EOS
;
      intersect, x(i), fndvi(i), x(i+1), fndvi(i+1), x(i),ffma(i),x(i+1), ffma(i+1),fxint,fyint,fptsc

      fslope = ffma(i+1)-ffma(i)
      bslope = fbma(i+1)-fbma(i)
      nslope = fndvi(i+1)-fndvi(i)

      fxpts[i] = fxint
      fypts[i] = fyint
      fcpts[i] = float(fptsc)

      if(fptsc gt 0 and fslope lt nslope) then begin
         Start_End.SOST[soscnt] = fxpts[i]   
         Start_End.SOSN[soscnt] = fypts[i]   
         soscnt=soscnt+1
      END

;
; Backward for EOS
;
      intersect, x(i), fndvi(i), x(i+1), fndvi(i+1), x(i),fbma(i),x(i+1), fbma(i+1),bxint,byint,bptsc


      bxpts[i] = bxint
      bypts[i] = byint
      bcpts[i] = float(bptsc)


      if(bptsc gt 0 and bslope gt nslope) then begin
         Start_End.SOST[eoscnt] = bxint   
         Start_End.SOSN[eoscnt] = byint   
         eoscnt=eoscnt+1
      END


   END



Return, Start_End
END
