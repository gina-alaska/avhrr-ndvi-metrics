pro	readlac, file, ch, flag

nl = 100
ns = 600
bytint = 0

;
; reads AVHRR/LAC images (10 bands)
;
; bytint = 0 if data are byte, otherwise assumed i*2
;

ch=fltarr(ns,nl,10)
c2 = bytarr(ns,nl*9)

openr, 1, file
if bytint eq 0 then pix=assoc(1,bytarr(ns,nl))
if bytint ne 0 then pix=assoc(1,intarr(ns,nl))

;print,'reading file...'
for i = 0, 9 do begin
  ch(*,*,i)=float(rotate(pix(i),7))
endfor

close,1

;
; move konza to second position in image field
; bump everything else over one
;

tmp = ch(500:599,*,*)
ch(500:599,*,*) = ch(400:499,*,*)
ch(400:499,*,*) = ch(300:399,*,*)
ch(300:399,*,*) = ch(200:299,*,*)
ch(200:299,*,*) = ch(100:199,*,*)
ch(100:199,*,*) = tmp

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
;print,'preparing image for display'
window,1,xs=ns,ys=nl*9

c2(0:599,0:99)=bytscl(alog(ch(*,*,0)+.0001))
c2(0:599,100:199)=bytscl(ch(*,*,1) > 0.)
c2(0:599,200:299)=bytscl(ch(*,*,2) > 0.)
c2(0:599,300:399)=bytscl(ch(*,*,3) > 0.)
c2(0:599,400:499)=bytscl(ch(*,*,4) > 0.)
c2(0:599,500:599)=bytscl(ch(*,*,5) > 0.)
c2(0:599,600:699)=bytscl(ch(*,*,6) > 0.)
c2(0:599,700:799)=bytscl(ch(*,*,7) > 0.)
c2(0:599,800:899)=bytscl(ch(*,*,8) > 0.)
tv,c2
endif

return
end
