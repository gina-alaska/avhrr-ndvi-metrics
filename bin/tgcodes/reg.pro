FUNCTION   reg, ref, serimg, sstar, lstar

nlref = n_elements(ref(0,*))
nsref = n_elements(ref(*,0))

ser = imgcopy(serimg, sstar, lstar, 100,100)

nlser = n_elements(ser(0,*))
nsser = n_elements(ser(*,0))

corrsurf = fltarr(nsref-nsser, nlref-nlser) 

for l = 0, nlref-nlser-1 do begin

  for s = 0, nsref-nsser-1 do begin
    chip = imgcopy(ref, s, l, nsser, nlser)
    pcor, chip, ser, r

    corrsurf(s,l) = r

  endfor

endfor

;surface, corrsurf

peakidx = where(corrsurf eq max(corrsurf))

lpeak = long(peakidx) / (nlref-nlser)
speak = long(peakidx) mod (nlref-nlser)

loff = lstar - lpeak
soff = sstar - speak

offsets = ([soff, loff])

;chipsurf = corrsurf(speak(0)-1:speak(0)+1, lpeak(0)-1:lpeak(0)+1)
;surfit = sfit(chipsurf, 2, kx = coefs)
;print, "COEFS= ", coefs
;for l = -1, 1 do begin

;   print, corrsurf(speak(0)-1:speak(0)+1, lpeak(0)-l)

;endfor
;print, ""
;return, coefs
return, offsets
;return, corrsurf
end 

