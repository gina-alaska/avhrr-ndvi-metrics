;=== PLANCK_CWN ==========================================
;  This procedure calculates the blackbody radiance 
;  (mW/m2-sr-cm-1) at temperature, T(K) and central wave 
;  number, cwn(cm-1)
;
;  It requires that the header file, radtrans.h, be
;  available (this is where constants are stored)    
;========================================================= 
FUNCTION   planck, T, cwn

; Source the header file where the constants, C1 and C2
; reside
@radtrans.h


; Apply Planck equation
   T = double(T)
   cwn = double(cwn)
   R = cwn^3*C1 / (exp(cwn*C2/T) - 1.0) ;

return, R

end
