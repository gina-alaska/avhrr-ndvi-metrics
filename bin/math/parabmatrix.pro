PRO   parabmatrix, A

;
; Generate normal matrix for fitting 3x3 surface
; with:
;
;    c0(x^2) + c1(x*y) + c2(y^2) + c3(x) + c4(y) + c5 
;
; Used in correlation surface peak fitting
;

A = dblarr(6, 9)

m = 0
for y = -1.0, 1.0, 1.0 do begin

  for x = -1.0, 1.0, 1.0 do begin

    A(0, m) = x^2 
    A(1, m) = x*y
    A(2, m) = y^2 
    A(3, m) = x 
    A(4, m) = y 
    A(5, m) = 1 

    m = m+1
  endfor
endfor

 
end
