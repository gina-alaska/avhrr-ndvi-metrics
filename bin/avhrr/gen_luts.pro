
;
; BYTE DATA
;
openw,1,"byte_lut.out"
for i = 1, 255 do begin
  x =  i
  t3 = tfix(x, 3, /byte)
  t4 = tfix(x, 4, /byte)
  t5 = tfix(x, 5, /byte)
  printf,1, i, t3, t4, t5
endfor
close,1

;
; I*2 DATA
;
openw,1,"i2_lut.out"
for i = 10, 1018 do begin
  x = (i)
  t3 = tfix(x, 3, /i2)
  t4 = tfix(x, 4, /i2)
  t5 = tfix(x, 5, /i2)
  printf,1, i, t3, t4, t5
endfor
close,1

end 
