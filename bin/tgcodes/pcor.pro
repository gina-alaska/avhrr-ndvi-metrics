pro pcor, x, y, r

;
; computes pearson's correlation coefficient for x vs y (r is coef)
; assumes x,y are arrays of equal size
;

n = n_elements(x)
m = n_elements(y)

if (n eq m) then begin
  sumx = total (x)
  sumy = total (y)
  sumxx = total (x*x)
  sumyy = total (y*y)
  sumxy = total (x*y)
  num = n*sumxy - sumx*sumy
  den = sqrt (n*sumxx - sumx*sumx) * sqrt (n*sumyy - sumy*sumy)
  r = num/den
endif

end
