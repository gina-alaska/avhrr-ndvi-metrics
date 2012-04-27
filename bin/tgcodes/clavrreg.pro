pro clavrreg, c, d, jday, snow, site, flag

;
; does CLAVR (CLouds from AVhRr) - THIS VERSION DOES 94x94 REGISTERED
;					    IMAGES OF ONE SITE 
;
;
; INPUTS:
;
; c is standard 94x94x{10 or 12} input.  See readreg.pro
; jday is julian date - JULDAY(1,1,1994)
; snow is BOOLEAN FLAG: 0 means no snow, 1 means there is enough
;	snow to affect the NDVI test
; site tells which site to do ([0,5])
;
; flag controls display; 0-nothing, 1-pretty picture
;
; OUTPUTS:
;
; d = "scores" for test:
;
;	d(0) = total score for each acquisition (# of tests detecting clouds)
;	d(1) = RGC variable	"
;	d(2) = RRC  "		" 
;	d(3) = C3A  "		"
;	d(4) = FMF  "		"
;	d(5) = TGC  "		"
;	d(6) = shadow estimate (1 - possibility of shadow)
;
;       to use time varying thresholds for tests (red,ndv,tmp), insert
;		parameters "jday" which is the julian date
;
; ref: Stowe, L. L., et al, Global distribution of cloud cover derived from
; NOAA/AVHRR operational satellite system  "Advances in Space Research"
; v11 #3 pp (3)51-(3)54, 1991 (COSPAR)
;

d=c
d2r=3.1415926d0/180.d0


; Niobrara is our benchmark site, because we have climate data for it.

red = [.20,.20,.20,.18, .17,.26,.12,.12,.14,   .20,.20,.20,.20,.20]
ndv = [.10,.10,.10,.10, .13,.26,.41,.39,.28,  .15,.15,.10,.10,.10]
tgc = [260,260,265,270, 289,291,297,296,296,   280,275,275,270,260]
fmr = [2,  2,  2,  2  ,   0,  0,  0,  0,  0,       2,  2,  2,  2,  2]

dat = [-15,15, 46, 74,  105,135,166,196,227,  258,288,319,349,380]

; now set up the offsets; these will be added to the benchmark
; thresholds.  (Niobrara has offsets, too, but they're set to zero.)
; this was only done for Tallgrass and Matador.  Konza will be the
; same as Tallgrass, while Ordway and Cross Ranch will be equal
; to Niobrara.

redoff=fltarr(14,6)
redoff(*,0) = [0,0,0,0, -.01,-.06,.01,.05,.05, 0, 0, 0, 0, 0]
redoff(*,1) = [0,0, -.04,-.02,-.02,-.1,.02,.04,.05,0,0,0,0,0 ]
redoff(*,5) = [0,0,0,0, .01,-.12,.01,.07,.11, 0, 0, 0, 0, 0]
red=red+redoff(*,site)

ndvoff=fltarr(14,6)
ndvoff(*,0) = [0,0,0,0, .05,-.03,-.08,-.13,-.13,  0, 0, 0, 0, 0]
ndvoff(*,1) = [0,0,0,.03, 0,-.01,-.09,-.08,-.06,  0, 0, 0, 0, 0]
ndvoff(*,5) = [0,0,0,0, -.035,-.16,-.15,-.18,-.2, 0, 0, 0, 0, 0]
ndv=ndv+ndvoff(*,site)

fmroff=fltarr(14,6)
fmroff(*,0) = [0,0,0,0, .5,.5,.5,.5,.5, 0, 0, 0, 0, 0]
fmroff(*,1) = [0,0,0,0, .5,.5,.5,.5,.5, 0, 0, 0, 0, 0]
fmroff(*,5) = [0,0,0,0, .5,.5,.5,.5,.5, 0, 0, 0, 0, 0]
fmr=fmr+fmroff(*,site)

tgcoff=fltarr(14,6)
tgcoff(*,0) = [0,0,0,0, 2,4,-4,-3,-5, 0, 0, 0, 0, 0]
tgcoff(*,0) = [0,0,5,12, 0,-2,-1,-3,-5, 0, 0, 0, 0, 0]
tgcoff(*,5) = [0,0,0,0, -8,-7,-5,-4,-10, 0, 0, 0, 0, 0]
tgc=tgc+tgcoff(*,site)

;
; the following variables are for ch 3 Planck equation
;

c1=1.1910659d-5
c2=1.438833d0
nu=2670.95d0
nu3=nu*nu*nu
s3=16.62d0

;
; RGCT, reflectance gross cloud test; is channel 1 reflectance > .44?
;

t1 = interpol (red,dat,jday)
rgc = c(*,*,0)
d(*,*,1) = rgc
rgct = (rgc gt t1(0))
shad1 = rgc lt t1(0)/2.


;
; RRCT, reflectance ration cloud test: is ratio of ch2 to ch1 is near unity?
; (yes = cloud)
;
; if the snow flag is set then threshold is reduced by 30% (this is a
; completely arbitrary amount and probably could be improved.)

t2 = interpol(ndv,dat,jday)
if snow then t2=t2*.70
rr = f_ndvi(c(*,*,0),c(*,*,1))
rrct = (rr lt t2(0)) and (rr ge 0)
d(*,*,2) = rr

;
; C3AT, channel 3 albedo test: separate emissive and reflective components
; of ch 3 signal, is cloudy if ch 3 reflectance is high (> .06)
;

t3e = 2.211d0*c(*,*,3)-1.211d0*c(*,*,4)+0.773d0
bt3 = c1*nu3/(exp(c2*nu/c(*,*,2))-1.0d0)
bt3e = c1*nu3/(exp(c2*nu/t3e)-1.0d0)
delr3 = bt3-bt3e
c3a = 3.1415926d0*delr3/(cos(c(*,*,7)*d2r)*s3)
c3at = (c3a ge .06)
d(*,*,3) = c3a
shad3 = c3a lt 0

; FMFT, (four-minus-five test): use discrepancy between brightness temps
; in ch4 and ch5 to detect the presence of ice clouds; this difference is
; roughly proportional to ice content and hence is sensitive to cirrus
;

t4 = double(c(*,*,3))
fmf = t4*0.0
for i = 0, 93 do begin
  for j = 0, 93 do begin
    t = t4(j,i)
    case 1 of
      (t le 260.): fmf(j,i) = 0.0d0
      (t ge 305.): fmf(j,i) = 7.8d0
    else: fmf(j,i) = $
-1.34436d4 + 1.94945d2*t - 1.05635d0*t*t + 2.53361d-3*t*t*t - 2.26786d-6*t*t*t*t
    endcase
  endfor
endfor
tt4 = interpol(fmr,dat,jday)
fmft = (t4-c(*,*,4)) ge (fmf+tt4(0))
d(*,*,4) = (t4-c(*,*,4)-fmf)

;
; TGCT thermal gross cloud test: if very cold, it must be a cloud
;

t5 = interpol(tgc,dat,jday)
tgct = (c(*,*,3) lt t5(0))
d(*,*,5) = c(*,*,3)

;
; compute cloud scores
;

d(*,*,0) = rgct + rrct + c3at + fmft + tgct
d(*,*,6) = shad1 and shad3

if (flag ne 0) then begin

; dtv=bytarr(600,500)
; dtv(*,0:99) =    bytscl(alog(d(*,*,1) + .0001))
; dtv(*,100:199) = bytscl(d(*,*,2))
; dtv(*,200:299) = bytscl(alog((d(*,*,3) > 0) + .0001))
; dtv(*,300:399) = bytscl(d(*,*,4))
; dtv(*,400:499) = bytscl(d(*,*,5))
; window, 2, xs=600, ys=500
; tvscl, dtv

  ddv=bytarr(94,658)
  ddv(*,0:93)=     rgct*5
  ddv(*,94:187) = rrct*5
  ddv(*,188:281) = c3at*5
  ddv(*,282:375) = fmft*5
  ddv(*,376:469) = tgct*5
  ddv(*,470:563) = d(*,*,0)
  ddv(*,564:657) = d(*,*,6)
  window, 2, xs=94, ys=658
  tvscl, ddv

endif

return
end
