pro	meanplot, tt, nn, jd, cl
;	tsa, tss, tta, tts, $
;	nsa, nss, nta, nts

;
; computes space and time means for temp (tt) and ndvi (nn)
;
;	tsa - spatial average (one for each time slot)
;	tta - time average (one for each spatial pixel)
;	nsa, nta, etc.
;	tss - spatial std dev (etc).
;

tsa = fltarr(40) & nsa = tsa
tss = fltarr(40) & nss = tss
tta = fltarr(94,94) & nta = tta
tts = fltarr(94,94) & nts = tts

;
; cloud test tolerance (# positive cloud tests allowed)
;

tol = 0.0

;
; spatial averages
;

for i = 0, 39 do begin

  ncl0 = where (cl(*,*,i) eq tol)

  tt0 = tt(*,*,i)
  xx = moment (tt0(ncl0))
  tsa(i) = xx(0)
  tss(i) = sqrt (xx(1))

  nn0 = nn(*,*,i)
  xx = moment (nn0(ncl0))
  nsa(i) = xx(0)
  nss(i) = sqrt (xx(1))

endfor

;
; plot spatial averages against time
;

window, 0, xs=600, ys=600
!p.multi = [0,1,2]
plot, jd, tsa-273.15, ysty=16, xtitle = 'date', $
	ytitle = 'average temp (C)'
oplot, jd, (tsa-273.15) + tss, line=1, color = 150
oplot, jd, (tsa-273.15) - tss, line=1, color = 150
ttg = gaussfit (jd, (tsa-273.15))
oplot, jd, ttg, line=2, color=75

plot, jd, nsa, ysty=16, xtitle = 'date', $
	ytitle = 'average NDVI'
oplot, jd, nsa + nss, line=1, color = 150
oplot, jd, nsa - nss, line=1, color = 150
nng = gaussfit (jd, (nsa))
oplot, jd, nng, line=2, color=75

!p.multi = 0

window, 1
plot, tsa-273.15, nsa, psym=5,$
	xtitle='temp', ytitle='ndvi'

;
; time averages
;

for j = 0, 94-1 do begin
  for i = 0, 94-1 do begin

    ncl1 = where (cl(i,j,*) eq tol)

    tt1 = tt(i,j,*)
    xx = moment (tt1(ncl1))
    tta(i,j) = xx(0)
    tts(i,j) = sqrt (xx(1))

    nn1 = nn(i,j,*)
    xx = moment (nn1(ncl1))
    nta(i,j) = xx(0)
    nts(i,j) = sqrt (xx(1))

  endfor
endfor

;
; plot time averages as images
;

picture = bytarr(94*3,94*2)
picture(0:94-1,0:94-1) = bytscl(tta(*,*))
picture(94:94*2-1,0:94-1) = bytscl(tts(*,*))
picture(94*2:94*3-1,0:94-1) = bytscl(tta(*,*)/tts(*,*))
picture(0:94-1,94:94*2-1) = bytscl(nta(*,*))
picture(94:94*2-1,94:94*2-1) = bytscl(nts(*,*))
picture(94*2:94*3-1,94:94*2-1) = bytscl(nta(*,*)/nts(*,*))
bigpic = congrid (picture, 94*6, 94*4, /cubic)

window, 2, xs=94*6, ys=94*4
tv, bigpic
loadct, 13

return
end
