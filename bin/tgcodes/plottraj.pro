; PRO   plottraj, listfile,site
listfile='~/rad/lists/tgreglist.94'
site = 0
;=== READ FILE CONTAINING IMAGE LIST AND INFO ===
readlist2,listfile,nim,imgdim,path,classimg,imgname

;=== SET UP SOME CONSTANTS ===
SEGDAYS   = 14   ; bin up images in 14 day segments
WINDOWNUM =  2
CHIPDIM   =  5
;VARDIM = imgdim - (CHIPDIM-1) 
;VARDIM = long(imgdim)  /CHIPDIM 
VARDIM = imgdim
;=== ALLOCATE SPACE FOR ARRAYS ===
NVar = fltarr(VARDIM, VARDIM)
TVar = fltarr(VARDIM, VARDIM)
CloudSum = fltarr(imgdim,imgdim)
NdviVarSum = fltarr(VARDIM, VARDIM)
TVarSum = fltarr(VARDIM, VARDIM)

;=== SIZE IMAGE WINDOWS ===
window, WINDOWNUM, xs=4*imgdim, ys=imgdim
;window, WINDOWNUM+1, xs = 2*CHIPDIM*VARDIM, ys = CHIPDIM*VARDIM

;=== SET UP LIST OF JULIAN DATES FOR FILES
jd = fltarr(nim)
for i=0, nim-1 do jd(i) = j2d(imgname(i))



;=== START LOOPING THROUGH DAYS TO EXTRACT 'SEGDAYS' DAY INTERVALS ===
for i=0,300,SEGDAYS do begin

  seg = where(jd ge i and jd lt i+SEGDAYS, nsegs)

;====== IF THERE IS DATA IN THE 'SEGDAYS' SEGMENT, CALCULATE STATS ===
  if (nsegs gt 0) then begin
    for j = 0, nsegs-1 do begin

        readone, path(0)+ imgname(seg(j)),c,0,imgdim

        ndvi = getchip(c,0,5,imgdim)               ; Extract NDVI chip
        t5 = getchip(c,0,4,imgdim)                 ; Extract band 5 chip
        t4 = getchip(c,0,3,imgdim)                 ; Extract band 4 chip
        t = tavhrr(t4,t5,4)                        ; Calculate surface T
        clavrreg,c,cloudtest,jd(seg(j)),0,site,0   ; Create cloud cover image
        clouds = cloudtest(*,*,0)
        NoCloudIdx = where (clouds eq 0)           ; Get cloud free indices
CloudSum = CloudSum + clouds


    ;=== CALCULATE VARIANCE IN NDVI AND T CHIPS ===
        ;for l = 0, VARDIM - 1  do begin
        ;  for s = 0, VARDIM - 1 do begin
        for l = 2, VARDIM - 3  do begin
          for s = 2, VARDIM - 3 do begin

            NChip = imgcopy(ndvi, s-2, l-2, CHIPDIM, CHIPDIM)
            TChip = imgcopy(t, s-2, l-2, CHIPDIM, CHIPDIM)
            CChip = imgcopy(clouds, s-2, l-2, CHIPDIM, CHIPDIM)
            CChipidx = where (CChip eq 0, nCChipidx)

            if(nCChipidx gt CHIPDIM*CHIPDIM/2) then begin
              NVar(s,l) = stdev(NChip(CChipidx))
              TVar(s,l) = stdev(TChip(CChipidx))
            endif else begin
              NVar(s,l) = 9.
              TVar(s,l) = 9.
            endelse

          endfor ; s loop on samples
        endfor ; l loop on lines
NdviVarSum  = NdviVarSum + NVar
TVarSum     = TVarSum + TVar

;wset, WINDOWNUM+1
;tvscl, rebin(NVar, CHIPDIM*VARDIM, CHIPDIM*VARDIM, /sample)
;tvscl, rebin(TVar, CHIPDIM*VARDIM, CHIPDIM*VARDIM, /sample), $
;              xs=CHIPDIM*VARDIM,ys=0


print, "Day = ",i,  j
wset, WINDOWNUM
tvscl, ndvi
tvscl, t, imgdim, 0
tvscl, clouds, 2*imgdim, 0 
tvscl, CloudSum, 3*imgdim, 0, Channel=1
tvscl, NdviVarSum, 3*imgdim, 0, Channel=2
tvscl, TVarSum, 3*imgdim, 0, Channel=3

     endfor ; j loop on nsegs
  endif 

endfor ; i loop on days


bNdviVarSum = bytscl(NdviVarSum)
bTdviVarSum = bytscl(TdviVarSum)
bCloudSum   = bytscl(CloudSum)

end
