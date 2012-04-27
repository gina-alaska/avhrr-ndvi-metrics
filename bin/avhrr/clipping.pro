;=== NOAA14FIX ===
;  This procedure reads all

@noaa14cal.h

;path = "/sg1/sab1/suarezm/rad/us96/tg96/"
;file = "tg9606231925.img"
;file = "tg9604181938.img"
;file = "tg9606201957.img"
readlist, "~/rad/us96/tg96good/noclouds10", nim, path, files
ns = 100
nl = 1200

;pathfile = path+file
path(0)="~/rad/us96/tg96/"


openw, 10, "clipping10.dat" 

for i = 0, nim-1 do begin
pathfile = path+files(i)

   data = imgread(pathfile(0), ns, nl)
;   datascl = avhrrunscale(data, /byte, /ref)
   datascl=data
;   ndvi = getband(datascl, 5)
   T3 = getband(datascl, 2)
   T4 = getband(datascl, 3)
   T5 = getband(datascl, 4) 
;Tbefore = tavhrr(t4,t5,4)

;   T3c = quadtbad(T3, coef3)
;   T4c = quadtbad(T4, coef4)
;   T5c = quadtbad(T5, coef5)
;Tafter = tavhrr(t4c,t5c,4)

tmphi3 = where(T3 eq 255, nhi3)
tmplo3 = where(T3 eq 0, nlo3)

tmphi4 = where(T4 eq 255, nhi4)
tmplo4 = where(T4 eq 0, nlo4)

tmphi5 = where(T5 eq 255, nhi5)
tmplo5 = where(T5 eq 0, nlo5)

print, i, "  ",files(i), nhi3, nlo3, nhi4, nlo4
printf,10, files(i),nhi3, nlo3, nhi4, nlo4, nhi5

endfor
close,10

;   showsite, datascl, 0
;
;   !P.Multi=[0,2,2]
;   window, 11, xs = 1000, ys=700
;
;   xmin = floor(min(t4))
;   xmax = ceil(max(t4))
;   x = findgen(xmax-xmin) + xmin
;
;   plot, (x), histogram(t4), psym=10, xstyle=1, $
;    Title="Incorrectly Processed", $
;    Xtitle="Temperature, (K)"
;
;   xmin = floor(min(t4c))
;   xmax = ceil(max(t4c))
;   x = findgen(xmax-xmin) + xmin
;
;   plot, (x), histogram(t4c), psym=10, xstyle=1, $
;    Title="Post Process Correction", $
;    Xtitle="Temperature, (K)"
;
;
;   xmin = floor(min(tbefore))
;   xmax = ceil(max(tbefore))
;   x = findgen(xmax-xmin) + xmin
;
;   plot, (x), histogram(tbefore), psym=10, xstyle=1, $
;    Title="TBefore", $
;    Xtitle="Temperature, (K)"
;
;   xmin = floor(min(tafter))
;   xmax = ceil(max(tafter))
;   x = findgen(xmax-xmin) + xmin
;
;   plot, (x), histogram(tafter), psym=10, xstyle=1, $
;    Title="TAfter", $
;    Xtitle="Temperature, (K)"
;
;
;
   print, n_elements(where(T4 ge 255))
   print, n_elements(where(T4 lt 100))

end
