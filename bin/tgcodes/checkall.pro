pro	checkall

;
; checks all sites in all 305 images for viewing angles, clouds.
;

true=1 & false=0

nim = 305
ttl = strarr(6)
ttl(0) = 'Tallgrass'
ttl(1) = 'Konza'
ttl(2) = 'Niobrara'
ttl(3) = 'Ordway'
ttl(4) = 'Cross'
ttl(5) = 'Matador'

data=lonarr(nim,6,2)

str = strarr(nim)
openr, 1, 'image.masterlist'
readf, 1, str
close, 1

;
; do the time stuff (julian date, time of day from file names)
;

mon = strmid (str, 16, 2)
day = strmid (str, 18, 2)
hour = strmid (str, 20, 2)
min = strmid (str, 22, 2)
jday = fltarr(nim)
day1 = julday (1, 1, 1994)
for i = 0, nim-1 do begin
  jday(i) = julday (mon(i), day(i), 1994) - day1
endfor
frac = hour/24. + min/1440.
jday = jday + frac

;
; main process loop
;

for i = 0, nim-1 do begin

  print, 'image: ', strmid (str(i), 16, 8)
  readlac, str(i), c, 0
  clavr, c, d, jday(i), 0

  for j=0,5 do begin
    print, "  "+ttl(j)

; if test to determine if data are valid.  sensor data values = 0, or
; satellite zenith angles >= 57 degrees are considered invalid and not 
; computed.

    good=true

    if (max(c((100*j):(99+100*j),*,0:1)) eq 0) then good=false
    if (max(c((100*j):(99+100*j),*,0:1)) eq  $
		min(c((100*j):(99+100*j),*,0:1))) then good=false
    if (max(c((100*j):(99+100*j),*,6)) ge 57) then begin
	good=false
	print, "Viewing Problem!"
    endif
    for k=0,4 do if (max(c((100*j):(99+100*j),*,k)) eq $
	min(c((100*j):(99+100*j),*,k))) then good=false

    if good eq false then begin
      data(i,j,0)=1
      print, "*** Image Problem!"
    endif else begin

; compute cloud and cloud shadow mask. cloud mask is handled the same as
; snow mask.


      data(i,j,1)=total(d((100*j):(99+100*j),*,0) eq 0)

; print info

      print, data(i,j,0), data(i,j,1)

    endelse
  endfor
endfor

openw, 1, "image.allcheck"
printf, 1, data
close, 1

return
end
