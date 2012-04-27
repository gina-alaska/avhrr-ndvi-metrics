PRO   parabfit, chip, c, peak


nx = n_elements(chip(*,0))
ny = n_elements(chip(0,*))


; Set up 1D array from solution matrix
data = fltarr(nx*ny)

for k = 0, nx*ny - 1 do data(k) = chip(k mod nx , k/ny )

parabmatrix, A

c = lsq(A, data)

peak = fltarr(2)
peak(1) = (2*c(0)*c(4) - c(3)*c(1)) / (c(1)^2 - 4.*a(0)*a(2))
;peak(0) = -(c(4) + 2*c(2)*peak(1))/c(1)
peak(0) = -(c(1)*peak(1) + c(3))/(2.*a(0))

end

