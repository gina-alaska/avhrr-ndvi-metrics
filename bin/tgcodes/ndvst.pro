readlist, "noclouds5", nim, path, file
ns = 100
nl = 1200
window, 10, xs = 400, ys=300

for i = 0, nim-1 do begin

   pathfile = path(0)+file(i)

   data = imgread(pathfile, ns, nl)

   datascl = avhrrunscale(data, /byte, /ref)

   nd = getband(datascl, 5)
   T4 = getband(datascl, 3)
   T5 = getband(datascl, 4)
   cl = getband(datascl, 11)
   
   noclidx = where(cl eq 0)
   T = tavhrr(t4,t5,4)

   plot, k2f(t), nd, /nodata, $
    Title  = file(i), $
    XTitle = "T, (F)",  xrange = [20, 120], xstyle=1, $
    YTitle = "NDVI",    yrange = [0.0, .7], ystyle=1

   plots, [103.73, 103.73], [0,.7], line=0
   oplot, k2f(t4(noclidx)), nd(noclidx), psym=3
   plots, [103.73, 103.73], [0,.7], line=0

;   cursor,x,y, /wait
;   wait,1

endfor

end
