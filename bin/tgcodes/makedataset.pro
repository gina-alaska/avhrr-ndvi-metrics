pro makedataset, site, nim, infile 

; takes all the images named in <infile> and
; copies out the 100x100x10 site image.
;
; Note that this procedure does *NOT* take into 
; effect the shifts that readlac does... the user
; must specify the site in the actual file.  If there
; are more than 6 sites, the nsi variable should be
; changed.
;
; then it tacks on two extra bands.  ch11 might
; be snow in the future; ch12 is clavr results

nsi=6

name=strarr(6)
name(0)='tg'
name(1)='kz'
name(2)='nb'
name(3)='od'
name(4)='cr'
name(5)='md'

str=strarr(nim)
openr, 1, infile
readf, 1, str
close, 1

mon = strmid (str, 37, 2)
day = strmid (str, 39, 2)
hour = strmid (str, 41, 2)
min = strmid (str, 43, 2)
jday = fltarr(nim)
day1 = julday (1, 1, 1994)
for i = 0, nim-1 do begin
  jday(i) = julday (mon(i), day(i), 1994) - day1
endfor
frac = hour/24. + min/1440.
jday = jday + frac


tmp1=bytarr(100,100,12)

print, 'Creating 10 band images...'
; actually, these are 12 band images, but channel 11 is empty

for i=0,nim-1 do begin
  print, strmid(str(i),37,8)
  tmp=bytarr(nsi*100,100,10)
  openr, 1, str(i)
  readu, 1, tmp
  close, 1
  tmp=tmp(100*site:99+100*site,*,*)
  tmp1(0:99,0:99,0:9)=tmp(0:99,*,*)

  openw, 2, name(site)+strmid(str(i),37,8)+".img"
  writeu, 2, tmp1
  close, 2
endfor

print, 'Creating 12 band images....'

str=findfile("*.img")

for i=0,nim-1 do begin
  print, strmid(str(i),2,8)
  readone, str(i), c, 0
  clavrone, c, d, jday, [0,0,0,0,0,0], site, 0
  c=0

  openr, 1, str(i)
  readu, 1, tmp1  
  close, 1
  tmp1(0:99,0:99,11)=byte(rotate(d(*,*,0), 7))
  openw, 1, str(i)
  writeu, 1, tmp1
  close, 1
endfor

return
end
