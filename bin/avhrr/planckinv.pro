;=== PLANCKINV_CWN ===================================
;  This procedure calculates the blackbody temperature
;  in K for a radiance, R(mW/m2-sr-cm-1) and central 
;  wave number, cwn(cm-1)
;
;  It requires that the header file, radtrans.h, be    
;  available (this is where constants are stored)
;=====================================================
FUNCTION   planckinv, R, cwn


; Source header file where Planck constants C1 and C2
; reside

@radtrans.h


; Apply inverse Planck equation
   R =double(R)
   cwn = double(cwn)
   T = C2*cwn / (alog(C1*cwn^3/R + 1.0)) ;

   return, T

end
