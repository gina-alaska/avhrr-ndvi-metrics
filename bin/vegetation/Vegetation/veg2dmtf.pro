   fe = 1.


   xdmtf = [.48, .82, .93, 1., .93, .82, .48]
   ydmtf = [.53, .84, .94, 1., .94, .84, .53]
   freq=[-fe/2, -fe/4, -fe/8, 0., fe/8, fe/4, fe/2]

   n=128
   n2=n/2
   scale=50.
   magic2=2

;
; Frequency Calculations
;
   xgfit=gaussfit(freq,xdmtf,Ax, nterms=3, estimates=[1., 0., 0.5])
   ygfit=gaussfit(freq,ydmtf,Ay, nterms=3, estimates=[1., 0., 0.5])

   f = findgen(n)/n2 - 1
   x = findgen(n)

   zx = (f - Ax[1])/Ax[2]
   zsx= (f - Ax[1])*(scale/2)/Ax[2]

   zy = (f - Ay[1])/Ay[2]
   zsy= (f - Ay[1])*(scale/2)/Ay[2]


;
; Generate frequency domain MTFs
;
   a0x = 1/(Ax[2]*sqrt(2*!pi))
   a0sx = 1/(Ax[2]*sqrt(2*!pi)/(scale/4))

   a0y = 1/(Ay[2]*sqrt(2*!pi))
   a0sy = 1/(Ay[2]*sqrt(2*!pi)/(scale/4))


   xmtf = Ax[0]*exp(-(zx)^2/2)
   xmtfstretch = A0sx*(exp( -(zsx/magic2)^2 / 2 ))

   ymtf = Ay[0]*exp(-(zy)^2/2)
   ymtfstretch = A0sy*(exp( -(zsy/magic2)^2 / 2 ))

;   mtfsfit=gaussfit(f,mtfstretch,mcoefs,nterms=3,estimates=[23.,0,.02])

;
; Generate spatial domain PSFs
;

   psf0x =fft(shift(xmtf, n2), 1)
   psf0sx=fft(shift(xmtfstretch, n2), 1)

   psfx =shift(float(psf0x), n2)/n*2
   psfsx=shift(float(psf0sx), n2)/n2

   psf0y =fft(shift(ymtf, n2), 1)
   psf0sy=fft(shift(ymtfstretch, n2), 1)

   psfy =shift(float(psf0y), n2)/n*2
   psfsy=shift(float(psf0sy), n2)/n2


;
; Analytical stretched and unstretched
;
   psfax = exp(-2*(!pi*Ax[2]*(x-n2)/(scale/2))^2)
   int_ax = int_tabulated(x, psfax)
   psfax = psfax/int_ax
   int_ax = int_tabulated(x, psfax)

   psfay = exp(-2*(!pi*Ay[2]*(x-n2)/(scale/2))^2)
   int_ay = int_tabulated(x, psfay)
   psfay = psfay/int_ay
   int_ay = int_tabulated(x, psfax)

;
; Combine x and y
;
   psf2d = psfax # (psfay)
;   psf2d = psfax # (fltarr(256)+1.)

;!p.multi=[0,1,2]
window,0
shade_surf, psf2d, /xstyle, /ystyle

window,1
plot, psfax, /xstyle
oplot, psfay, color=rgb(255,0,0)

   psfayfit=gaussfit(x, psfax, coefax, nterms=3, estim=[1., 128., 19])
   psfayfit=gaussfit(x, psfay, coefay, nterms=3, estim=[1., 128., 19])

sum=fltarr(n)
for i = 0,n-1 do sum(i)=int_tabulated(x,psf2d[*,i])
print, "KERNEL VOLUME:",total(sum)

print, "CROSS TRACK PSF:",coefay
print, "ALONG TRACK PSF:",coefax

;
; Reset plotspace
;
   !P.Multi=[0,1,1]

END
