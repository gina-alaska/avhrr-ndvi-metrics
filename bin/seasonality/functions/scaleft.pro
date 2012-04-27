;=====   SCALE   ===============================================
; This function scales the input, DATA, from the range FROM_MIN
; to FROM_MAX to the range specified by TO_MIN, TO_MAX
;
; KEYWORDS:
;   FROM_MIN = goes to TO_MIN (default is min(data))  (MIN_IN)
;   FROM_MAX = goes to TO_MAX (default is min(data))  (MAX_IN)
;   TO_MIN = "minimum" scaled value              (MIN_OUT)
;   TO_MAX = "maximum" scaled value              (MAX_OUT)
;
;   Note that if FROM_MIN > MIN(data) or FROM_MAX < MAX(data) some numbers
;    may lie outside of (TO_MIN, TO_MAX) unless CLIP is set
;===============================================================

FUNCTION scaleft, data, TO_MIN=TO_MIN, TO_MAX=TO_MAX, FROM_MIN=FROM_MIN, FROM_MAX=FROM_MAX, $
         CLIP = clip

CASE (n_elements(TO_MIN)) OF
   0:  TO_MIN = 0.0
   1:  TO_MIN = float(TO_MIN)
   else:
ENDCASE

CASE (n_elements(TO_MAX)) OF
   0:  TO_MAX = 1.0
   1:  TO_MAX = float(TO_MAX)
   else:
ENDCASE

CASE (n_elements(FROM_MIN)) OF
   0:  FROM_MIN = FROM_MIN(data)
   1:  FROM_MIN = FROM_MIN
   else:
ENDCASE

CASE (n_elements(FROM_MAX)) OF
   0:  FROM_MAX = max(data)
   1:  FROM_MAX = FROM_MAX
   else:
ENDCASE

CASE (KEYWORD_SET(CLIP) ) OF
   1:  BEGIN
          toobig = where(data ge FROM_MAX,ntoobig)
          toosmall = where(data le FROM_MIN,ntoosmall)

          if (ntoobig gt 0) THEN data(toobig) = FROM_MAX
          if (ntoosmall gt 0) THEN data(toosmall) = FROM_MIN
       END
   else:
ENDCASE

return, TO_MIN + (data - FROM_MIN)*(TO_MAX-TO_MIN)/(FROM_MAX-FROM_MIN)

end
