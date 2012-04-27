;PRO ctest2, file
;
;  this is just a quick program to calculate the cloud mask
;  and show clouds and band 1
;
openr,1,"~/ctest.file"
file = ""
readf,1, file
close,1
print, "FILE = ",file


tfile="~/idl/bin/avhrr/clavrdir/tg96.dat"
TData = ReadThresh(tfile)
tgc = tdata.tgc
dat = [-15,15, 46, 74,  105,135,166,196,227,  258,288,319,349,380]


data = imgread3(file, 512,512,10, /i2)
datau = avhrrunscale(data, /i2, /ref)
jd = file2jul(file, year=1996)
clavr, datau, clouds1, jd, tfile=tfile

kernal = replicate(1., 3, 3)
clouds = dilate(clouds1(*,*,0), kernal)


ttop = interpol(tgc, dat, jd)

showimg, clouds(*,*,0), 14
showimg, alog(data(*,*,0)), 15


notcloud = where(clouds(*,*,0) eq 0)
cmask = mask(clouds(*,*,0), notcloud, /show)
t4 = datau(*,*,3)
nd = datau(*,*,5)

idx = uniqpair(t4, nd)
clearidx = uniqpair(t4(notcloud), nd(notcloud))

histo = myhist2d(t4, nd, xser, yser, $
        bin1 = 1, bin2 = 0.02, min1 = 260, min2 = -0.4,$
        max1 = 330, max2 = 0.8)


t4i = data(*,*,3)
ndi = data(*,*,5)



;
;  Try to get Tmin
;
;print, "TTOP =", ttop(0)
watidx = where(nd lt 0 and t4 gt ttop(0) and clouds(*,*,0) eq 0, nwatidx)
watthist = hist(t4(watidx), x, binsize=0.2)
gtzeroidx = where (watthist gt 0)
yfit = gaussfit(x, watthist, a, nterms=3)
wattavg = total(x*watthist)/total(watthist)
TMIN = wattavg-a(2)*3.
TMIN = wattavg - 3
TMIN2 = percentile(t4(watidx), 1.0)
;print, tmin

t4idx = where(clouds(*,*,0) eq 0)
Ncoefs = fitedge(nd(t4idx), t4(t4idx), 0, 0.5, DataToFit, Yfit=Tminedge)



;
; Try to get ND max
;
ndidx = where(nd gt 0 and t4 gt ttop(0) and clouds(*,*,0) eq 0 $
              and nd lt 1, nndidx)
NDMAX = percentile(nd(ndidx), 99.9)

ndidx2 = where(nd gt 0 and t4 ge wattavg-3 and t4 le wattavg+3 $
              and clouds(*,*,0) eq 0 $
              and nd lt 1, nndidx)
NDMAX2 = percentile(nd(ndidx2), 99.9)


;
; Try to get ND min
;
ndidx = where(nd gt 0 and clouds(*,*,0) eq 0 and t4 gt wattavg)
Ncoefs = fitedge(t4(ndidx), nd(ndidx), 0, 0.5, DataToFit, Yfit=ndmin)


;
; Try to get Tmax
;
tmaxidx = where(nd gt 0 and clouds(*,*,0) eq 0 and t4 gt Tmin)
;Tcoefs = fitedge(t4(tmaxidx), nd(tmaxidx), 2, 99.5, TMaxDataToFit, Yfit=tmax)
TMaxDataToFit = WarmEdge(t4(tmaxidx), nd(tmaxidx),99.5)
n = n_elements(TMaxDataToFit(0,*))
w = fltarr(n)+1.0
Tcoefs = PolyFitW(TMaxDataToFit(0,*), TMaxDataToFit(1,*), W,2, TMax)
tmpcoefs = tcoefs
tmpcoefs(0) = tcoefs(0)-ndmin(0)
tmax2 = quadratic(tmpcoefs, /negroot)


;
; Plot 'em all
;
!p.multi=[0,1,3]
window, 16, xs = 500, ys = 1000

plot, t4(idx), nd(idx), psym=3, xrange=[260, 330], yrange=[-0.4, 0.8], $
      /xstyle, /ystyle
oplot, t4(notcloud(clearidx)), nd(notcloud(clearidx)), psym=3, $
      color = rgb(255,255,128)
oplot, [tmin,tmin], [-0.4,0.8]
;oplot, [tmin2,tmin2], [-0.4,0.8], line = 1
;oplot, [min(xser), max(xser)], [NDMAX, NDMAX], line=1
oplot, [min(xser), max(xser)], [NDMAX2, NDMAX2]
oplot, [min(xser), max(xser)], [ndmin(0), ndmin(0)]
oplot, TMaxDataToFit(0,*), TMax
oplot, [tmax2,tmax2], [-0.4,0.8]

oplot, [min(yser), max(yser)], [tminedge(0), tminedge(0)], line = 0, $
color=rgb(255,255, 128)


imageplot, alog(histo+1), xser, yser, xmax = 330.
oplot, [tmin,tmin], [-0.4,0.8]
;oplot, [tmin2,tmin2], [-0.4,0.8], line = 1
;oplot, [min(xser), max(xser)], [NDMAX, NDMAX], line=1
oplot, [min(xser), max(xser)], [NDMAX2, NDMAX2]
oplot, [min(xser), max(xser)], [ndmin(0), ndmin(0)]
oplot, TMaxDataToFit(0,*), TMax
oplot, [tmax2,tmax2], [-0.4,0.8]

oplot, [min(yser), max(yser)], [tminedge(0), tminedge(0)], line = 0, $
color=rgb(255,255, 128)

;window,7, xs = 400, ys = 300
imageplot, histo, xser, yser, xmax = 330.
oplot, [tmin,tmin], [-0.4,0.8]
;oplot, [tmin2,tmin2], [-0.4,0.8], line = 1
;oplot, [min(xser), max(xser)], [NDMAX, NDMAX], line=1
oplot, [min(xser), max(xser)], [NDMAX2, NDMAX2]
oplot, [min(xser), max(xser)], [ndmin(0), ndmin(0)]
oplot, TMaxDataToFit(0,*), TMax
oplot, [tmax2,tmax2], [-0.4,0.8]

;window,8, xs = 400, ys = 300


!p.multi = [0,1,1]


PRINT, "FILE = ",file, " JD = ", jd
PRINT, "NDMin = ", ndmin(0)
PRINT, "NDMax = ", ndmax2
PRINT, "TMin  = ", Tmin
PRINT, "TMax  = ", TMax2


end
