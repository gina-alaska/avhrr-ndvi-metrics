pro clavr, cin, d, jday, dim, snow, site, flag, SATNUM=SatNum, TFILE=tfile

;
; does CLAVR (CLouds from AVhRr) - THIS VERSION DOES NxN PARTS
;
;
; INPUTS:
;
; c is standard NxNx{10 or 12} input.  See readone.pro
; jday is julian date - JULDAY(1,1,1994)
; snow is vector of 6 flags - snow(i) = does site i have enough snow to
;   affect the ndvi?
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
;
; SATNUM - keyword is used to specify parameters for the C3AT test, default is
;          14
; TFILE - data file (with path) containing test thresholds
;

IF (N_PARAMs() eq 3) THEN BEGIN
   snow=[0,0,0,0,0,0]
   site=0
   flag=0
ENDIF

CInSize=Size(CIn)
NSamps = CInSize(1)
NBands = CInSize(2)/CInSize(1)
Dim = NSamps



IF (CInSize(0) EQ 2) THEN BEGIN
   C = FltArr(NSamps, NSamps, NBands)
   FOR i=0, NBands-1 DO C(*,*,i) = getband(CIn, i, NSamps)
ENDIF ELSE C = CIn

d=c*0
d2r=3.1415926d0/180.d0

;
; Source the threshold data file
;
;@tg94.dat
;@tg96.dat
IF (NOT KEYWORD_SET(TFILE)) THEN $
  tfile="/sg1/sab1/suarezm/idl/bin/avhrr/clavrdir/tg96.dat" 

TData = ReadThresh(tfile)

red = TData.red
ndv = TData.ndv
fmr = TData.fmr
tgc = TData.tgc

;; Niobrara is our benchmark site, because we have climate data for it.
;
;red = [.20,.20,.20,.18, .17,.26,.12,.12,.14,   .20,.20,.20,.20,.20]
;ndv = [.10,.10,.10,.10, .13,.26,.41,.39,.28,  .15,.15,.10,.10,.10]
;tgc = [260,260,265,270, 289,291,297,296,296,   280,275,275,270,260]
;fmr = [2,  2,  2,  2  ,   0,  0,  0,  0,  0,       2,  2,  2,  2,  2]
;
dat = [-15,15, 46, 74,  105,135,166,196,227,  258,288,319,349,380]
;
;; now set up the offsets; these will be added to the benchmark
;; thresholds.  (Niobrara has offsets, too, but they're set to zero.)
;; this was only done for Tallgrass and Matador.  Konza will be the
;; same as Tallgrass, while Ordway and Cross Ranch will be equal
;; to Niobrara.
;
;redoff=fltarr(14,6)
;redoff(*,0) = [0,0,0,0, -.01,-.06,.01,.05,.05, 0, 0, 0, 0, 0]
;redoff(*,1) = [0,0, -.04,-.02,-.02,-.1,.02,.04,.05,0,0,0,0,0 ]
;redoff(*,5) = [0,0,0,0, .01,-.12,.01,.07,.11, 0, 0, 0, 0, 0]
;red=red+redoff(*,site)
;
;ndvoff=fltarr(14,6)
;ndvoff(*,0) = [0,0,0,0, .05,-.03,-.08,-.13,-.13,  0, 0, 0, 0, 0]
;ndvoff(*,1) = [0,0,0,.03, 0,-.01,-.09,-.08,-.06,  0, 0, 0, 0, 0]
;ndvoff(*,5) = [0,0,0,0, -.035,-.16,-.15,-.18,-.2, 0, 0, 0, 0, 0]
;ndv=ndv+ndvoff(*,site)
;
;fmroff=fltarr(14,6)
;fmroff(*,0) = [0,0,0,0, .5,.5,.5,.5,.5, 0, 0, 0, 0, 0]
;fmroff(*,1) = [0,0,0,0, .5,.5,.5,.5,.5, 0, 0, 0, 0, 0]
;fmroff(*,5) = [0,0,0,0, .5,.5,.5,.5,.5, 0, 0, 0, 0, 0]
;fmr=fmr+fmroff(*,site)
;
;tgcoff=fltarr(14,6)
;tgcoff(*,0) = [0,0,0,0, 2,4,-4,-3,-5, 0, 0, 0, 0, 0]
;tgcoff(*,0) = [0,0,5,12, 0,-2,-1,-3,-5, 0, 0, 0, 0, 0]
;tgcoff(*,5) = [0,0,0,0, -8,-7,-5,-4,-10, 0, 0, 0, 0, 0]
;tgc=tgc+tgcoff(*,site)
;


; the following variables are for ch 3 Planck equation
;

c1=1.1910659d-5
c2=1.438833d0

if(KEYWORD_SET(SATNUM)) THEN BEGIN
CASE SATNUM of
   9:   BEGIN
           nu = 2678.11d0
           s3 = 16.682d0
           a3 = 0.94249d0
           b3 = -2.6590d0
           c3 = 1.6855d0
           d3 = -1.25d0
        END
   11:  BEGIN
           nu = 2670.95d0
           s3 = 16.62d0
           a3 = 0.96242
           b3 = -2.12758
           c3 = 1.16516
           d3 = -0.744
        END
   else:BEGIN
           nu = 2645.899
           s3 = 15.805d0
           a3 = 1.000d0
           b3 = -2.915924d0
           c3 = 1.92754d0 ;? is second digit a 9 or a 4 ?
           d3 = -1.21284d0
        END
ENDCASE
ENDIF ELSE BEGIN
           nu = 2645.899
           s3 = 15.805d0
           a3 = 1.000d0
           b3 = -2.915924d0
           c3 = 1.92754d0 ;? is second digit a 9 or a 4 ?
           d3 = -1.21284d0
ENDELSE

nu3=nu*nu*nu
t3coef = [b3/a3, c3/a3, d3/a3]

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
; (ACTUALLY THIS HAS BEEN REPLACED BY THE NDVI TEST
;

t2 = interpol(ndv,dat,jday)
rr = f_ndvi(c(*,*,0),c(*,*,1))
rrct = (rr lt t2(0)) and (rr ge 0)
d(*,*,2) = rr

;
; C3AT, channel 3 albedo test: separate emissive and reflective components
; of ch 3 signal, is cloudy if ch 3 reflectance is high (> .06)
;

t3e = -(t3coef(0)*c(*,*,3))-(t3coef(1)*c(*,*,4))-t3coef(2)
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
for i = 0, dim-1 do begin
  for j = 0, dim-1 do begin
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
d(*,*,1) = rgct
d(*,*,2) = rrct
d(*,*,3) = c3at
d(*,*,4) = fmft
d(*,*,5) = tgct
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

  ddv=bytarr(dim,7*dim)
  ddv(*,0:1*dim-1)=     rgct*5
  ddv(*,1*dim:2*dim-1) = rrct*5
  ddv(*,2*dim:3*dim-1) = c3at*5
  ddv(*,3*dim:4*dim-1) = fmft*5
  ddv(*,4*dim:5*dim-1) = tgct*5
  ddv(*,5*dim:6*dim-1) = d(*,*,0)
  ddv(*,6*dim:7*dim-1) = d(*,*,6)
  window, 2, xs=dim, ys=7*dim
  tvscl, ddv

endif

return
end
