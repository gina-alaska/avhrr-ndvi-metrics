dim = 20

x = findgen(dim)+1.0
y = findgen(dim)+1.0

a = 5.182366
b = 3.27702

p=fltarr(dim,dim)
q=fltarr(dim,dim)


for i = 0, dim-1 do begin
   for j = 0, dim-1 do begin

      p(i,j) = (x(i) - y(j))/(x(i) + y(j))
      q(i,j) = (a*x(i) - b*y(j))/(a*x(i) + b*y(j))
   endfor
endfor

m=fltarr(dim*dim)
m(*) = p(*,*)
n=fltarr(dim*dim)
n(*) = q(*,*)



nvm2 = poly_fit(m,n,2,nfit2)
nvm3 = poly_fit(m,n,3,nfit3)
nvm4 = poly_fit(m,n,4,nfit4)

window,0
plot, m, n, psym=3
oplot, m,nfit2, psym=3, color=rgb(255,0,0)
oplot, m,nfit3, psym=3, color=rgb(0,255,0)
oplot, m,nfit4, psym=3, color=rgb(0,0,255)


window,1
plot, m, n-n, psym=3, yrange = [-0.01, 0.01], /ystyle
oplot, m, nfit2-n, psym=3, color=rgb(255,0,0)
oplot, m, nfit3-n, psym=3, color=rgb(0,255,0)
oplot, m, nfit4-n, psym=3, color=rgb(0,0,255)

end
