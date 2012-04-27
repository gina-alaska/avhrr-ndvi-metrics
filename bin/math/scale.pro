;=====   SCALE   ===============================================
; This function scales the input, DATA, from the range MIN to MAX
; to the range specified by XMIN, XMAX
;
; KEYWORDS:
;   MIN = goes to XMIN (default is min(data))  (MIN_IN)
;   MAX = goes to XMAX (default is min(data))  (MAX_IN)
;   XMIN = "minimum" scaled value              (MIN_OUT)
;   XMAX = "maximum" scaled value              (MAX_OUT)
;
;   Note that if MIN > MIN(data) or MAX < MAX(data) some numbers
;    may lie outside of (XMIN, XMAX)
;===============================================================

FUNCTION scale, data, XMIN=xmin, XMAX=xmax, MIN=min, MAX=max, $
         CLIP = clip

CASE (n_elements(XMIN)) OF
   0:  xmin = 0.0
   1:  xmin = float(xmin) 
   else:
ENDCASE

CASE (n_elements(XMAX)) OF
   0:  xmax = 1.0
   1:  xmax = float(xmax) 
   else:
ENDCASE

CASE (n_elements(MIN)) OF
   0:  min = min(data)
   1:  min = min 
   else:
ENDCASE

CASE (n_elements(MAX)) OF
   0:  max = max(data) 
   1:  max = max
   else:
ENDCASE

CASE (KEYWORD_SET(CLIP) ) OF
   1:  BEGIN
          toobig = where(data ge max,ntoobig)
          toosmall = where(data le min,ntoosmall)

          if (ntoobig gt 0) THEN data(toobig) = max
          if (ntoosmall gt 0) THEN data(toosmall) = min
       END
   else:
ENDCASE

return, xmin + (data - min)*(xmax-xmin)/(max-min)

end
