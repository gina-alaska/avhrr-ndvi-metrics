;=====   WAVG  === =========================================
; This code calculates a weighted average
;===========================================================
FUNCTION wavg, x, w

return, total(w*x)/total(w)

end
