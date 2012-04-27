PRO procok, listfile, tmethod, outfile;, data, datau, clouds

;
; OPEN OUTPUT FILE
;
OpenW, 10, outfile

;
; READ LIST OF IMAGE FILE NAMES
;
readlist, listfile, nim, path, file

;
; GET CLUSTER THRESHOLD INFO
;
tfile="~/idl/bin/avhrr/clavrdir/tg96.dat"
TData = ReadThresh(tfile)
tgc = tdata.tgc
ndv = tdata.ndv
thc = [285,   285,285,287,  295,298,305,  307,297,290,  287,285,285,  285]
dat = [-15,15, 46, 74,  105,135,166,196,227,  258,288,319,349,380]

;
; BEGIN PROCESSING LOOP
;
FOR i = 0, nim-1 DO BEGIN

   pathfile = path(0)+file(i)

   jd = file2jul(file(i), year=1996)
print, "READING: ",file(i)
   data = imgread3(pathfile, 512,512,11, /i2)
   datau = avhrrunscale(data, /ref, /i2)

   t4 = datau(*,*,3)
   t5 = datau(*,*,4)
   nd = datau(*,*,5)
   clouds = datau(*,*,10)

   if (tmethod gt 0) THEN $ 
      t = tavhrr(t4, t5, tmethod) $
   ELSE $
      t = t4

clear = where(clouds eq 0)
idx = uniqpair(t(clear),nd(clear))
histo = myhist2d(t4, nd, xser, yser, $
        bin1 = 1, bin2 = 0.02, min1 = 270, min2 = -0.4,$
        max1 = 350, max2 = 0.8)


;
; GET THE NDVI AND TGC THRESHOLDS USED IN CLAVR
;
   NDthresh = interpol(ndv, dat, jd)
   T4thresh = interpol(tgc, dat, jd)
   TLand = interpol(thc, dat, jd)

   NDmax = Get_NDmax(t, nd, clouds)
   NDmin = Get_NDmin(t, nd, Tland(0))
   
   Tmin =  Get_Tmin(t,nd,clouds,ndmax,ndthresh(0) )
   Tmax =  Get_Tmax(t,nd,clouds,tmin,ndmin,WarmCurve)
   
   print, file(i)
   print, "  NDmax = ", NDmax
   print, "  NDmin = ", NDmin
   print, "  Tmin  = ", Tmin
   print, "  Tmax  = ", Tmax

printf, 10, file(i), NDmax, NDmin, Tmax, Tmin

showimg, alog(data(*,*,0)), 0
showimg, data(*,*,10),1

window,2
plot, t(clear(idx)), nd(clear(idx)), psym=3, color = rgb(128,128,128),$
      yrange = [-0.2, .8], xrange = [270,350], /xstyle
oplot, [Tmin,Tmin],[NDmin,NDmax], line = 0, color = rgb(255,200,0)
oplot, [Tmax,Tmax],[NDmin,NDmax], line = 0, color = rgb(255,200,0)
oplot, [Tmin,Tmax],[NDmin,NDmin], line = 0, color = rgb(255,200,0)
oplot, [Tmin,Tmax],[NDmax,NDmax], line = 0, color = rgb(255,200,0)
oplot, WarmCurve(0,*), WarmCurve(1,*), line=0,color=rgb(255,200,0)

window,3
imageplot, alog(histo+1), xser, yser, xmax = 350.
oplot, [Tmin,Tmin],[NDmin,NDmax], line = 0, color = rgb(255,200,0)
oplot, [Tmax,Tmax],[NDmin,NDmax], line = 0, color = rgb(255,200,0)
oplot, [Tmin,Tmax],[NDmin,NDmin], line = 0, color = rgb(255,200,0)
oplot, [Tmin,Tmax],[NDmax,NDmax], line = 0, color = rgb(255,200,0)
oplot, WarmCurve(0,*), WarmCurve(1,*), line=0,color=rgb(255,200,0)


endfor
close, 10
end
