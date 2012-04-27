;==============   AVHRRTEMP.PRO   ==================
;
; This file contains several split-window algorithms  
; for calculating surface temperatures from AVHRR
;
; 1 - Deschamps & Phulpin (1980)
; 2 - McClain et al. (1983) 
; 3 - Price (1984)
; 4 - Singh (1984)
;===================================================

FUNCTION   tavhrr, T4, T5, Tflag

CASE Tflag OF

1 :  return, 2.626*(T4) - 1.626*(T5) - 1.1
2 :  return, 1.035*T4 + 3.046*(T4-T5) - 10.784
3 :  return, T4 + 3.33*(T4 - T5)
4 :  return, 1.699*T4 - 0.699*T5 - 0.240

ELSE: PRINT, 'ERROR: CHECK TFLAG'
ENDCASE

end
