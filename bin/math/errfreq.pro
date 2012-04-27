PRO   errfreq , psd, fpeakfreqs, PSFLAG=psflag     ; PSFLAG = 0:screen, 1:ps
path='/sgs8/disk1/suarezm/scanerrors/'
listfile = 'datlist'
openr,1, path+listfile
readf,1,nfiles

;=== SETUP PLOTTING DEVICE ===
screen=!D.Name
if (KEYWORD_SET(PSFLAG)) then begin
  set_plot, 'ps'
  device, xsize=7., ysize=9., yoffset=1, /inches, filename='averages.ps'
endif

;=== ALLOCATE SPACE FOR ARRAYS ===
filedata=replicate({SFile, month:0L, day:0L, year:0L, file:'string'}, nfiles)
jd = intarr(nfiles)
fracyear = fltarr(nfiles)
avgaf = fltarr(nfiles)
avgar = fltarr(nfiles)
ffherr=fltarr(187)
fsherr=fltarr(187)
rfherr=fltarr(187)
rsherr=fltarr(187)
ffreq =fltarr(nfiles)
rfreq =fltarr(nfiles)
frfreq =fltarr(nfiles)
AFR = fltarr(374)

readf, 1, filedata
close,1
!P.Multi=[0,1,3]
;nfiles=1
for i = 0, nfiles-1 do begin

   filedata(i).file = strmid(filedata(i).file, 1, strlen(filedata(i).file)-1)
   jd(i) = julday(filedata(i).month, filedata(i).day, filedata(i).year)
   fracyear(i) = filedata(i).year+filedata(i).month/12. + filedata(i).day/365.

   openr,LUN, path+filedata(i).file+'.dat', /GET_LUN

   for j=0, 186  DO BEGIN
      readf,LUN,a
      ffherr(j) = a
      readf,LUN,a
      fsherr(j) = a
      readf,LUN,a
      rfherr(j) = a
      readf,LUN,a
      rsherr(j) = a
   endfor

   FREE_LUN, LUN
   af = calcaf(ffherr, fsherr)
   ar = calcar(rfherr, rsherr)
  for k=0,186 DO BEGIN
    AFR(k*2) = af(k)-avg(af) 
    AFR(k*2+1) = ar(k)-avg(ar) 
  endfor
window,0
  cr=''
  fftex, af, fpeakfreqs
  fftex, ar, rpeakfreqs 
  fftex, AFR, FRPEAKFREQS

  ffreq(i) = fpeakfreqs(1)
  rfreq(i) = rpeakfreqs(1)
  frfreq(i)= frpeakfreqs(1)

  print, i, 1./fpeakfreqs(1:5)
  print, i, 1./rpeakfreqs(1:5)
  print, i, 1./frpeakfreqs(1:5)
;  read, "Press Return to continue, q to stop:", cr
;  if(cr eq 'q') then goto, ENDPOINT 

window,2
plot, af
plot, ar
plot, AFR
cursor, x, y, wait=1

endfor

;jd = jd - min(jd)

!P.Multi=[0,1,3]
if !D.Name eq 'X' then $
 window,1,xs=1000, ys=600
plot, fracyear, 1./ffreq, /ynozero, psym=4
plot, fracyear, 1./rfreq, /ynozero, psym=4
plot, fracyear, 1./frfreq, /ynozero, psym=4

ENDPOINT:
;=== RETURN DEVICE TO SCREEN ===
if(KEYWORD_SET(PSFLAG)) then device, /close
set_plot, screen

end
