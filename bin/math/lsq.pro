FUNCTION   lsq, A, z

;
;  The most basic possible implementation of a least
;  squares method.  
;
;  'A' is the matrix of normal vectors, eg a row of 
;  'A' might look like:  [x^2, x, 1]  for fitting
;  a parabola.
;
;  z is the solution vector.
; 
;  The return value is the vector of polynomial
;  coefficients which best satisfies:  Ac = z
; 


AD = double(a)
B = transpose(AD)
zd = double(z)

return, (invert(B##AD)##B)##zd

end
