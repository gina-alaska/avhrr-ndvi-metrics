   fe = 1.


   dmtf = [.48, .82, .93, 1., .93, .82, .48]
   freq=[-fe/2, -fe/4, -fe/8, 0., fe/8, fe/4, fe/2]

   n=256
   n2=n/2
   scale=50.
   magic2=1

;
; Frequency Calculations
;
   gfit=gaussfit(freq,dmtf,A, nterms=3, estimates=[1., 0., 0.5])

   f = findgen(n)/n2 - 1

   z = (f - A[1])/A[2]
   zs=(f-A[1])*(scale/2)/A[2]

   x = findgen(n)

;
; Generate frequency domain MTFs
;
   a0 = 1/(a[2]*sqrt(2*!pi))
   a0s = 1/(a[2]*sqrt(2*!pi)/(scale/4))

;   Asmall = a[2]*!pi*sqrt(2.0) / (scale/2)

   mtf = A[0]*exp(-(z)^2/2)
   mtfstretch = a0s*(exp( -(zs/magic2)^2 / 2 ))

   mtfsfit=gaussfit(f,mtfstretch,mcoefs,nterms=3,estimates=[23.,0,.02])

;
; Generate spatial domain PSFs
;

   psf0 =fft(shift(mtf, n2), 1)
   psf0s=fft(shift(mtfstretch, n2), 1)

   psf =shift(float(psf0), n2)/n*2
   psfs=shift(float(psf0s), n2)/n2


;
; Analytical stretched and unstretched
;
   psfa = exp(-2*(!pi*A[2]*(x-n2)/(scale/2)/2)^2)
   psfau= exp(-2*(!pi*A[2]*(x-n2))^2)

;
; Plotting
;
   !P.Multi=[0,1,2]
   window,0, XSize=600, YSize=1000

   Plot, f, mtf, /XStyle
   oPlot, f, mtfstretch, color=rgb(255,0,0)
   oplot, freq, dmtf, psym=4, color=rgb(0,255,255)



   plot, psf, color=rgb(255,255,255), /Xstyle
   oPlot, x, psfa, color=rgb(0,255,0)
   oplot, psfs, color=rgb(255,0,0)
;   oplot, psfau, color=rgb(255,255,0)


   oplot, x+scale, psfa, color=rgb(0,255,0)
   oplot, x-scale, psfa, color=rgb(0,255,0)

   psfafit=gaussfit(x, psfa, coefa, nterms=3, estim=[1., 128., 19])
   psfsfit=gaussfit(x, psfs, coefs, nterms=3, estim=[1., 128., 19])

   print, "MCOEFS:",mcoefs
   print, "COEF_A:",coefa
   print, "COEF_S:",coefs

   print, "INT_MS:",int_tabulated(f, mtfstretch)
   print, "INT_A:", int_tabulated(x, psfa)
   print, "INT_S:", int_tabulated(x, psfs)

;
; Reset plotspace
;
   !P.Multi=[0,1,1]

END
