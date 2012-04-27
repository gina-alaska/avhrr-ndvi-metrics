FUNCTION  Sinc, x

;
; This Function calculates the value of the sinc function
; for a given x where x is a number or an array
;
;   Sinc = sin(x)/x           (x is in radians)
;

Zero = where(x EQ 0, nZero)
NotZero = where(x NE 0, nNotZero)

nx = n_Elements(x)
ret=fltarr(nx)

IF nZero GT 0 THEN ret[Zero] = 1.0
IF nNotZero GT 0 THEN ret[NotZero] = sin(x[NotZero])/x[NotZero]

IF nx EQ 1 THEN ret = ret[0]

Return, ret
END
