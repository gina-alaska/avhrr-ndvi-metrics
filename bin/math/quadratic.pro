;=== QUADRATIC =================================
;  This procedure solves the quadratic equation
;  for the roots of a quadratic function, or if
;  the quadratic term is zero, it solves the
;  linear equation.  
;  The default in the quadratic case is to grab
;  the root using the + sign, but the keyword
;  NEGROOT can be set to grab the - case
;===============================================
FUNCTION   quadratic, coef, NEGROOT = negroot 


if(coef(2) ne 0.0) then begin
   if(KEYWORD_SET(NEGROOT)) then $
      x = (-coef(1) - sqrt(coef(1)^2 - 4.*coef(0)*coef(2))) / (2.*coef(2)) $
   else $
      x = (-coef(1) + sqrt(coef(1)^2 - 4.*coef(0)*coef(2))) / (2.*coef(2))

   root=x

endif else root = -coef(0)/coef(1)


   return, root

end
