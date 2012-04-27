pro	readreg, file, ch, flag

nl = 94
ns = 94
bytint = 0

; this version assumes 94x94x10 registered images

;
; channel 11 - empty for now.  Possibly snow cover later on?
; channel 12 - output from clavrchips. (actually, clavrone)

; bytint = 0 if data are byte, otherwise assumed i*2
;
; this is the same as earlier versions of readlac except that when
; a picture is displayed the three angle bands are left out.
; (this way it fits on an 832x624 Mac screen...)


ch=fltarr(ns,nl,12)
c2 = bytarr(ns,nl*6)

openr, unit, file, /GET_LUN
if bytint eq 0 then pix=assoc(unit,bytarr(ns,nl))
if bytint ne 0 then pix=assoc(unit,intarr(ns,nl))

;print,'reading file...'
for i = 0, 9 do begin
  ch(*,*,i)=float(rotate(pix(i),7))
endfor

FREE_LUN, unit

;
; now calibrate the data
;

;print,'calibrating and scaling data'
rscal=1000.
tscal=10.
toff=0.
if bytint eq 0 then begin
  rscal=400.
  tscal=2.
  toff=202.5
endif

ch(*,*,0)=ch(*,*,0)/rscal
ch(*,*,1)=ch(*,*,1)/rscal
ch(*,*,2)=ch(*,*,2)/tscal+toff
ch(*,*,3)=ch(*,*,3)/tscal+toff
ch(*,*,4)=ch(*,*,4)/tscal+toff
ch(*,*,5)=ch(*,*,5)/100-1
ch(*,*,6)=abs(90-ch(*,*,6))

;
; for your viewing pleasure
;

if (flag ne 0) then begin

; this next line used to be "...ys=nl*9"

window,1,xs=ns,ys=nl*6

c2(*,0:93)=bytscl(alog(ch(*,*,0)+.0001))
c2(*,94:187)=bytscl(ch(*,*,1) > 0.)
c2(*,188:281)=bytscl(ch(*,*,2) > 0.)
c2(*,282:375)=bytscl(ch(*,*,3) > 0.)
c2(*,376:469)=bytscl(ch(*,*,4) > 0.)
c2(*,470:563)=bytscl(ch(*,*,5) > 0.)

; Here are the left out bands.

; c2(0:99,700:799)=bytscl(ch(*,*,7) > 0.)
; c2(0:99,800:899)=bytscl(ch(*,*,8) > 0.)
tv,c2
endif

return
end
