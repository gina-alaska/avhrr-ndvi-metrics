;  f_ndvi.pro      22 May 92           (c) Michel M. Verstraete

;  Purpose:

;     IDL function to return the value of the NDVI on the basis of two AVHRR
;     channel values given as arguments.

;  Usage:

;     nd = f_ndvi (c1, c2)

;  Remarks:

;  1. This function accepts scalars, vectors or matrices as arguments.
;  2. To maximize computing efficiency, the code does not check the validity of
;     the arguments, which are supposed to be real numbers between 0.0 and 1.0.
;  3. A value of -1.0 is returned if both channels are null.

function f_ndvi, c1, c2

c1pc2 = c1 + c2
ndvi = (c1pc2 eq 0.0) * (- 1.0) + $
   (c1pc2 gt 0.0) * (c2 - c1) / (c1pc2 + 1.0 * (c1pc2 eq 0.0))

return, ndvi
end
