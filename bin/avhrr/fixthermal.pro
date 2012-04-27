openw,OUT_LUN,"lut.out",/GET_LUN

@noaa14cal.h

path = "/sg1/sab1/suarezm/rad/us96/tg96/"
file = "tg9604181938.img"
pathfile = path+file
ns = 100
nl = 1200


rawdata = imgread(pathfile, ns, nl)

;=== Grab bad thermal band
rawt3 = getband(rawdata, 2)
rawt4 = getband(rawdata, 3)
rawt5 = getband(rawdata, 4)


;=== Scale them to Kelvin
sclt3 = b2k(rawt3)
sclt4 = b2k(rawt4)
sclt5 = b2k(rawt5)

for i = 0,255 do begin
;=== Scale them to Kelvin
sclt3 = b2k(i)
sclt4 = b2k(i)
sclt5 = b2k(i)



;=== Back out linear temperature
lint3 = quadtbad(sclt3, coef3)
lint4 = quadtbad(sclt4, coef4)
lint5 = quadtbad(sclt5, coef5)


;=== Get linear radiance
linr3 = planck(lint3, cwn3)
linr4 = planck(lint4, cwn4)
linr5 = planck(lint5, cwn5)

;=== Apply non-linearity to radiance
r3 = poly(linr3, coef3)
r4 = poly(linr4, coef4)
r5 = poly(linr5, coef5)


;=== Get correct temperature
t3 = planckinv(r3, cwn3)
t4 = planckinv(r4, cwn4)
t5 = planckinv(r5, cwn5)

lt0 = where (r3 lt 0 or t3 lt 203, nlt0)
if (nlt0 gt 0) then t3(lt0) = 203.

;print, t3, t4, t5

;=== Convert back to byte
bytt3 = k2b(t3)
bytt4 = k2b(t4)
bytt5 = k2b(t5)

;bytround = long(round(bytt4))
;byttrunc = long(bytt4)


;roundavg = avg(bytround)
;truncavg = avg(byttrunc)
;bytt4avg = avg(bytt4)

;printf, OUT_LUN, i, sclt4, t4, (bytround), (byttrunc), bytround-byttrunc

printf, OUT_LUN, format='(i2, 6f10.5)',i, sclt3, lint3, linr3, r3, t3, bytt3

endfor
FREE_LUN, OUT_LUN

;print, roundavg, truncavg, bytt4avg, bytt4avg-roundavg, bytt4avg-truncavg

;window, 10, xs = 300, ys = 100
;tvscl, rawt3 - bytt3, 0,0
;tvscl, rawt4 - bytt4, 100,0
;tvscl, rawt5 - bytt5, 200,0

;window, 0
;plot, sclt4, tavhrr(sclt4, sclt5, 4),color=rgb(255,255,255), $
;  /nodata ,$
;  xrange = [280, 330], xstyle=1, $
;  yrange = [-10, 20], ystyle=1
;oplot, sclt4, tavhrr(sclt4, sclt5, 4)-sclt4, psym=4, color=rgb(255,0,0)
;oplot, t4, tavhrr(t4,t5,4)-t4, psym=5, color=rgb(0,0,255)

end

