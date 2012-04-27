window, 20, xs=1024, ys=1024
num=8
size = size(datau)
dim = size(1)
!p.multi = [0,num,num]

for i = 0, num-1 DO BEGIN
  for j = 0, num-1 DO BEGIN
  

     t4chip = datau(j*dim:j*dim+dim-1, i*dim:i*dim+dim-1, 3)
     ndchip = datau(j*dim:j*dim+dim-1, i*dim:i*dim+dim-1, 5)

     plot, t4chip, ndchip, psym=3, xrange=[260, 330], yrange =[-.4,.8], $
           /xstyle, /ystyle, xmargin=[3,2], ymargin=[2,2]

  endfor
endfor

end
