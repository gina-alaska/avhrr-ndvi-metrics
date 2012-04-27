FUNCTION  fpp, f, x 

;
;  This approximates a second derivative 
;


FSize = Size(f)
Nf = FSize(1)

XSize = Size(x)
Nx = XSize(1)

RESULT = fltarr(Nx-2)

if (Nx ne Nf) then MESSAGE, "X and F must be of same size"


FOR i = 1, Nx-2 DO BEGIN

   RESULT(i-1) = (f(i+1) + f(i-1) - 2*f(i)) / (x(i+1)-x(i-1))^2

ENDFOR

RETURN, RESULT

END
