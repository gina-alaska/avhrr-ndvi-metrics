PRO   chiptraj, l,s,pcolor, PLOT = plot

if(N_PARAMS() eq 3) then pcolor=pcolor $
else pcolor = rgb(255,255,255)

; PRO   chiptraj, listfile,site
;s = 17
;l = 85
;s = 36
;l = 11
;s = 42
;l = 23
;s=72
;l=75

MINNUMSEGS=1
listfile='~/rad/lists/tgreglist.94'
site = 0
;=== READ FILE CONTAINING IMAGE LIST AND INFO ===
readlist2,listfile,nim,imgdim,path,classimg,imgname

;=== SET UP SOME CONSTANTS ===
SEGDAYS   = 28   ; bin up images in 14 day segments
WINDOWNUM =  2
CHIPDIM   =  5


;=== SIZE IMAGE WINDOWS ===

;=== SET UP LIST OF JULIAN DATES FOR FILES
jd = fltarr(nim)
for i=0, nim-1 do jd(i) = j2d(imgname(i))

jseg=0
DaysNAvg = fltarr(300/SEGDAYS + 1)
DaysTAvg = fltarr(300/SEGDAYS + 1)

;=== START LOOPING THROUGH DAYS TO EXTRACT 'SEGDAYS' DAY INTERVALS ===
for idays=0,230,SEGDAYS do begin
  NAvg = -999.0
  TAvg = -999.0
  W    = 1.
;  SegNAvg = 0.0
;  SegTAvg = 0.0
  NAvg = 0.0
  TAvg = 0.0
  jlocal = 0 
  seg = where(jd ge idays and jd lt idays+SEGDAYS, nsegs)

;====== IF THERE IS DATA IN THE 'SEGDAYS' SEGMENT, CALCULATE STATS ===
  if (nsegs ge MINNUMSEGS) then begin
NAvg = fltarr(nsegs)
TAvg = fltarr(nsegs)
W    = fltarr(nsegs)
    for jseg = 0, nsegs-1 do begin


        readone, path(0)+ imgname(seg(jseg)),c,0,imgdim

        ndvi = getchip(c,0,5,imgdim)               ; Extract NDVI chip
        t5 = getchip(c,0,4,imgdim)                 ; Extract band 5 chip
        t4 = getchip(c,0,3,imgdim)                 ; Extract band 4 chip
        t = tavhrr(t4,t5,4)                        ; Calculate surface T

        clavrreg,c,cloudtest,jd(seg(jseg)),0,site,1   ; Create cloud cover image
        clouds = cloudtest(*,*,0)
;window, 2, xs=6*imgdim, ys=imgdim
;for CImgIdx = 0, 5 do tvscl, cloudtest(*,*,CImgIdx), imgdim*CImgIdx, 0


    ;=== CALCULATE TRAJECTORY OF NDVI AND T CHIPS ===

        NChip = imgcopy(ndvi, s-2, l-2, CHIPDIM, CHIPDIM)
        TChip = imgcopy(t, s-2, l-2, CHIPDIM, CHIPDIM)
        CChip = imgcopy(clouds, s-2, l-2, CHIPDIM, CHIPDIM)
        CChipIdx = where (CChip eq 0, nCChipIdx)

        if( nCChipIdx eq 0) then jlocal = jlocal + 1
        if( nCChipIdx gt 0 ) then begin
           NAvg(jseg-jlocal) = avg(NChip(CChipIdx))
           TAvg(jseg-jlocal) = avg(TChip(CChipIdx))
           W(jseg-jlocal)    = float(nCChipIdx)/float(CHIPDIM^2)

;print, 'IN IF       ', idays, jseg, NAvg(jseg-jlocal), TAvg(jseg-jlocal), nCChipIdx

;           SegNAvg = (SegNAvg*(jseg-jlocal) + NAvg)/((jseg-jlocal) +1.)
;           SegTAvg = (SegTAvg*(jseg-jlocal) + TAvg)/((jseg-jlocal) +1.)

        endif

;print, 'INNER LOOP  ', idays, jseg, SegNAvg, SegTAvg

     endfor ; jseg loop on nsegs
  endif 

DaysNAvg(idays/SEGDAYS) = wavg(NAvg, W) ;SegNAvg
DaysTAvg(idays/SEGDAYS) = wavg(TAvg, W) ;SegTAvg


;print, 'OUTER LOOP  ', idays, jseg, SegNAvg, SegTAvg
print, 'OUTER LOOP  ', idays, jseg, DaysNAvg(idays/SEGDAYS), DaysTAvg(idays/SEGDAYS) 
endfor ; idays loop on days

wset,0
TNotZero = where(DaysTAvg ne 0)
if (KEYWORD_SET(PLOT)) then begin
  plot, DaysTAvg(TNotZero), DaysNAvg(TNotZero), /ynozero ,color=pcolor,$
        yrange = [0.0, 0.8]
endif else begin
  oplot, DaysTAvg(TNotZero), DaysNAvg(TNotZero), color=pcolor
endelse

;for i=0, N_Elements(DaysTAvg)-1 do $
;  xyouts, DaysTAvg(i), DaysNAvg(i), i, align=1

end
